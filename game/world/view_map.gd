## The map part of the world view (M26.1, ADR 0041): the ground tiles and
## edge pieces, map objects, tile props, signs and way-out arrows (M16.3),
## the crowd (M16.4) and the animated objects. WorldView makes and owns one;
## `_v` is the view (untyped: no script cycle).
class_name ViewMap
extends RefCounted

const TILE := ViewArt.TILE
const U := ViewArt.U
## Frames per second of animated objects (a fire).
const ANIM_FPS := 6.0
const OBJECT_COLOR := Color("#e8c547")
## M16.3: the way-out arrow (an exit with no sign), its outline and the size of its points.
const ARROW_COLOR := Color(1.0, 1.0, 1.0, 0.75)
const ARROW_EDGE := Color(0.08, 0.08, 0.08, 0.6)
## A sign hangs this many px above the floor line of the wall cell it is drawn on.
const SIGN_LIFT := 4

var _v
## Each sign / arrow label with its cell: {"label": Label, "cell": Vector2i}; faded by the player's distance.
var _sign_labels: Array[Dictionary] = []
## The crowd (M16.4): one entry per walker, {"marker": Node2D, "sprite": CharacterSprite, "lane": Dictionary,
## "i": int, "n": int, "step": int}; moved in `move_crowd` by real time.
var _crowd: Array[Dictionary] = []
var _crowd_time := 0.0
var _hour := 12
## Animated object sprites on the map now, and the animation clock.
var _animated: Array[Sprite2D] = []
var _anim_time := 0.0
var _mix_cache := {}


func _init(view) -> void:
	_v = view


## Draws map `id`: the ground, edges, props, marks, crowd and objects; tells
## the Atmosphere its lights and emits the area's object loops.
func show_area(id: String) -> void:
	var maps: MapDb = _v._maps
	var winter: bool = _v._winter
	var tiles: TileMapLayer = _v.tiles
	var props: Node2D = _v.props
	var marks: Node2D = _v.marks
	tiles.clear()
	(_v.edges as TileMapLayer).clear()
	_free_children(_v.mixes)
	_free_children(_v.fx)
	_free_children(props)
	_animated.clear()
	var size := maps.size(id)
	var ground := GroundArt.plan(maps, id, winter)
	for y in size.y:
		for x in size.x:
			var cell := Vector2i(x, y)
			var t := maps.tile_at(id, cell)
			var art: Dictionary = ground.get(cell, {})
			if art.is_empty() or not _set_art(tiles, cell, art["base"]):
				tiles.set_cell(cell, 0, _v.atlas[t])
			if art.has("over"):
				_set_art(_v.edges, cell, art["over"])
			if art.has("mix"):
				_add_mix(cell, art["mix"])
			_add_prop(t, cell)
	_free_children(marks)
	_sign_labels.clear()
	for m: Dictionary in SignArt.marks(maps, id):
		_add_mark(m)
	_show_crowd(id)
	var object_art: Dictionary = _v.object_art
	var light_sources: Array = []
	for o: Dictionary in maps.objects_on(id):
		var cell := Vector2i(int(o["at"][0]), int(o["at"][1]))
		var light := Atmosphere.light_of(object_art.get(String(o.get("kind", "")), {}))
		if not light.is_empty():
			light_sources.append({"cell": cell, "light": light})
		var look_art := ViewArt.object_look(o, object_art, winter)
		if not look_art.is_empty():
			_add_sprite(look_art["sheet"], look_art["region"], cell, look_art["frames"])
			continue
		var at := Vector2(cell * TILE)
		ViewArt.rect(marks, at + Vector2(2, 2) * U, Vector2(TILE - 4 * U, TILE - 4 * U), OBJECT_COLOR)
		var label := Label.new()
		label.text = String(o["name"]).left(1)
		label.add_theme_font_size_override("font_size", 16)
		label.add_theme_color_override("font_color", Color.BLACK)
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		marks.add_child(label)
		label.position = at + (Vector2(TILE, TILE) - label.get_minimum_size()) / 2.0
	(_v.atmosphere as Atmosphere).show_area(maps.is_indoor(id), light_sources)
	_v.area_loops.emit(AmbiencePick.loops_on(maps, id, object_art))
	var camera: Camera2D = _v.camera
	camera.limit_left = 0
	camera.limit_top = 0
	camera.limit_right = size.x * TILE
	camera.limit_bottom = size.y * TILE


## The clock moved to `hour`: walkers show only within their lane's hours.
func set_hour(hour: int) -> void:
	_hour = hour
	_apply_crowd_hours()


## One frame of real time: the crowd walks and animated objects turn their frames.
func tick(delta: float) -> void:
	_move_crowd(delta)
	if _animated.is_empty():
		return
	_anim_time += delta
	var step := int(_anim_time * ANIM_FPS)
	for s in _animated:
		var n := int(s.get_meta("frames"))
		s.region_rect.position.x = float(s.get_meta("x0")) + (step % n) * s.region_rect.size.x


## Fades each sign label by how far the player (at `at`) is from it.
func update_sign_labels(at: Vector2i) -> void:
	for s: Dictionary in _sign_labels:
		if is_instance_valid(s["label"]):
			(s["label"] as Label).modulate.a = SignArt.label_alpha(SignArt.king_dist(at, s["cell"]))


static func _free_children(parent: Node) -> void:
	for child in parent.get_children():
		parent.remove_child(child)
		child.queue_free()


## One SignArt mark (M16.3): a hanging sign in the y-sorted Props layer, or a way-out arrow, and a
## name label that shows when the player is near. The marker (in the Marks layer) holds the arrow and
## the label and has the meta "mark" = the mark's kind. No sign art: a small square.
func _add_mark(m: Dictionary) -> void:
	var cell: Vector2i = m["cell"]
	var marker := Node2D.new()
	marker.set_meta("mark", String(m["kind"]))
	marker.position = ViewArt.cell_center(cell)
	var label_top := 10.0
	if m["kind"] == "arrow":
		var holder := Node2D.new()
		holder.rotation = Vector2.DOWN.angle_to(Vector2(m["dir"]))
		holder.add_child(ViewArt.poly(PackedVector2Array([Vector2(-8, -6), Vector2(8, -6), Vector2(0, 6)]), ARROW_EDGE))
		holder.add_child(ViewArt.poly(PackedVector2Array([Vector2(-5, -4), Vector2(5, -4), Vector2(0, 3)]), ARROW_COLOR))
		marker.add_child(holder)
	elif m["kind"] == "sign":
		var region := SignArt.icon_region(_v.sign_table, String(m["icon"]))
		var hang := cell
		match String(m["place"]):
			"right":
				hang += Vector2i.RIGHT
			"left":
				hang += Vector2i.LEFT
		var lift := float(SIGN_LIFT)
		if m["place"] == "above":
			lift = float(_object_height(String(m["id"]))) if m["source"] == "object" else float(TILE)
		var at := ViewArt.cell_center(hang) - Vector2(0, lift)
		if region.size == Vector2.ZERO:
			ViewArt.rect(_v.marks, at - Vector2(3, 3) * U, Vector2(6, 6) * U, OBJECT_COLOR)
			marker.position = at
		else:
			var s := ViewArt.region_sprite("signs", region)
			s.position = at
			(_v.props as Node2D).add_child(s)
			marker.position = at
			label_top = region.size.y - TILE / 2.0 + 2.0  # just above the board
	if String(m["text"]) != "":
		var label := ViewArt.add_label(marker, String(m["text"]), label_top)
		label.modulate.a = 0.0
		_sign_labels.append({"label": label, "cell": cell})
	(_v.marks as Node2D).add_child(marker)


## The crowd of the area (M16.4, `Crowd`): a marker with a CharacterSprite per walker in the y-sorted
## Props layer (so it clears with them). A look with no sheet gives no walker; nothing else is drawn.
func _show_crowd(id: String) -> void:
	_crowd.clear()
	_crowd_time = 0.0
	var data: Variant = (_v._maps as MapDb).areas[id].get("crowd", {})
	if not data is Dictionary:
		return
	var budget := Crowd.MAX_WALKERS
	for lane: Dictionary in (data as Dictionary).get("lanes", []):
		var n := Crowd.count(lane, budget)
		budget -= n
		for i in n:
			var sprite := CharacterSprite.make(Crowd.look_of(lane, i))
			if sprite == null:
				continue
			var marker := Node2D.new()
			marker.set_meta("crowd", true)
			marker.add_child(sprite)
			(_v.props as Node2D).add_child(marker)
			var w := Crowd.walker(lane, i, n, 0.0)
			marker.position = ViewArt.cell_center(w["cell"])
			sprite.pose(String(w["dir"]))
			_crowd.append({"marker": marker, "sprite": sprite, "lane": lane, "i": i, "n": n, "step": int(w["step"])})
	_apply_crowd_hours()


## Shows each walker only within its lane's hours.
func _apply_crowd_hours() -> void:
	for w: Dictionary in _crowd:
		(w["marker"] as Node2D).visible = Crowd.active(w["lane"], _hour)


## Real-time crowd: a walker whose step changed jumps a cell and glides there (`CharacterSprite.walk`).
func _move_crowd(delta: float) -> void:
	if _crowd.is_empty():
		return
	_crowd_time += delta
	for w: Dictionary in _crowd:
		var now := Crowd.walker(w["lane"], w["i"], w["n"], _crowd_time)
		if int(now["step"]) == int(w["step"]):
			continue
		w["step"] = int(now["step"])
		var marker: Node2D = w["marker"]
		var from := marker.position
		marker.position = ViewArt.cell_center(now["cell"])
		if marker.visible and from != marker.position and from.distance_to(marker.position) <= TILE * 1.5:
			(w["sprite"] as CharacterSprite).walk(String(now["dir"]), from - marker.position, Crowd.STEP_SEC)
		else:
			(w["sprite"] as CharacterSprite).pose(String(now["dir"]))


## The pixel height of the art of the object `id` on this area (32 when it has none).
func _object_height(id: String) -> int:
	for o: Dictionary in (_v._maps as MapDb).objects_on(_v.area):
		if o["id"] == id:
			var art := ViewArt.object_look(o, _v.object_art, _v._winter)
			return int((art["region"] as Rect2).size.y) if not art.is_empty() else TILE
	return TILE


## A tile's prop (a tree, a rock) on `cell`: a region of its sheet (in
## cells), bottom-centred on the cell, in the y-sorted Props layer.
func _add_prop(tile: String, cell: Vector2i) -> void:
	var s := ViewArt.tile_prop((_v._maps as MapDb).tiles, tile, _v._winter)
	if s != null:
		s.position = ViewArt.cell_center(cell)
		(_v.props as Node2D).add_child(s)


## A region (pixels) of a sheet, bottom-centred on `cell`, in the y-sorted
## Props layer. With `frames` > 1 it is animated (the frames follow to the right).
func _add_sprite(sheet: String, region: Rect2, cell: Vector2i, frames: int = 1) -> Sprite2D:
	var s := ViewArt.region_sprite(sheet, region)
	s.position = ViewArt.cell_center(cell)
	(_v.props as Node2D).add_child(s)
	if frames > 1:
		s.set_meta("frames", frames)
		s.set_meta("x0", region.position.x)
		_animated.append(s)
	return s


## Draws `art` ([sheet, cell of the sheet]) on `cell` of `layer`; false when
## the sheet or its cell is missing (the caller draws the colour square).
func _set_art(layer: TileMapLayer, cell: Vector2i, art: Array) -> bool:
	var path := ViewArt.sheet_path(String(art[0]))
	if path == "":
		return false
	var ts := (_v.tiles as TileMapLayer).tile_set
	var id := -1
	for i in ts.get_source_count():
		var sid := ts.get_source_id(i)
		var src := ts.get_source(sid) as TileSetAtlasSource
		if src != null and src.texture != null and src.texture.resource_path == path:
			id = sid
			break
	if id < 0:
		var s := TileSetAtlasSource.new()
		s.texture = load(path)
		s.texture_region_size = Vector2i(TILE, TILE)
		id = ts.add_source(s)
	var atlas_src: TileSetAtlasSource = ts.get_source(id)
	var c: Vector2i = art[1]
	var cells := atlas_src.texture.get_size() / TILE
	if c.x < 0 or c.y < 0 or c.x >= int(cells.x) or c.y >= int(cells.y):
		return false
	if not atlas_src.has_tile(c):
		atlas_src.create_tile(c)
	layer.set_cell(cell, id, c)
	return true


## A cell whose ground needs several edge pieces at once (GroundArt.mix): a
## sprite over the Edges layer. The mixed picture is made once per combination.
func _add_mix(cell: Vector2i, mix: Dictionary) -> void:
	var key := "%s|%s" % [mix["sheet"], mix["cells"]]
	if not _mix_cache.has(key):
		var path := ViewArt.sheet_path(String(mix["sheet"]))
		if path == "":
			return
		var image: Image = (load(path) as Texture2D).get_image()
		_mix_cache[key] = ImageTexture.create_from_image(
				GroundArt.mix(image, mix["cells"], mix["fill"], TILE))
	var sprite := Sprite2D.new()
	sprite.texture = _mix_cache[key]
	sprite.centered = false
	sprite.position = Vector2(cell * TILE)
	(_v.mixes as Node2D).add_child(sprite)
