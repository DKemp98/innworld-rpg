## The effects of the world view (M26.1, ADR 0041). M11.3: AnimDiff changes
## play on the markers (a glide, a red flash and a damage number, a fall, a
## swing or a square's lunge, a gone monster's fade). M17.3 (ADR 0027): the
## turn replay, one fighter at a time with the camera on it. WorldView makes
## and owns one; `_v` is the view (untyped: no script cycle).
class_name ViewEffects
extends RefCounted

const TILE := ViewArt.TILE
const U := ViewArt.U
## One step glide, the same as the held-key repeat in main.gd.
const STEP_TIME := 0.14
## A hit: the unit is tinted this colour, back to normal in FLASH_TIME.
const HIT_TINT := Color(1.0, 0.25, 0.25)
const FLASH_TIME := 0.25
## Damage numbers rise NUMBER_RISE px and fade in NUMBER_TIME seconds.
const NUMBER_TIME := 0.8
const NUMBER_RISE := 8.0 * U
const HURT_YOU_COLOR := Color("#ff5a5a")
const HURT_OTHER_COLOR := Color("#fff2a8")
## A square's swing: it lunges this far toward the target and back.
const LUNGE := 3.0 * U
const LUNGE_TIME := 0.2
## A gone monster fades out in this time.
const GONE_TIME := 0.35
## Replay (M17.3): the camera's move to the next fighter, the pause after a
## fighter's turn, and a blow.
const CAMERA_TIME := 0.25
const REPLAY_PAUSE := 0.2
const BLOW_TIME := 0.3

var _v
## The walk-cycle half of each NPC (their markers are made anew each refresh).
var _halves: Dictionary = {}
var replaying := false
## Bumped by skip_replay, so a replay still waiting on a timer stops.
var _replay_run := 0
var _cam_tween: Tween


func _init(view) -> void:
	_v = view


## A new map: walk halves start over.
func clear() -> void:
	_halves.clear()


## Plays AnimDiff events on the markers drawn now. The player's own step is
## played by refresh (the sprite glide).
func play(changes: Array) -> void:
	for e: Dictionary in changes:
		var id := String(e["id"])
		var node := _unit_node(id)
		match e["type"]:
			AnimDiff.MOVE:
				if node != null and id != AnimDiff.PLAYER:
					_glide(node, id, Vector2(e["from"] - e["to"]) * TILE, e["dir"])
				if _is_monster(id):
					_v.monster_facing[id] = e["dir"]
			AnimDiff.HIT:
				if node != null:
					_flash(node)
					_number(node.position, int(e["amount"]), id == AnimDiff.PLAYER)
			AnimDiff.FALL:
				var lying := _sprite_of(node)
				if lying != null:
					lying.fall()
			AnimDiff.GONE:
				_fade_out(e["cell"], String(e["monster_type"]), String(_v.monster_facing.get(id, "s")))
			AnimDiff.SWING:
				if id != AnimDiff.PLAYER:
					_v.monster_facing[id] = e["dir"]
				var swinging := _sprite_of(node)
				if swinging != null:
					swinging.attack(e["dir"])
				elif node != null:
					_lunge(node, e["dir"])


## The marker id (AnimDiff) of an Encounter fighter id.
static func unit_of(fighter: String) -> String:
	if fighter == Encounter.PLAYER:
		return AnimDiff.PLAYER
	if fighter.begins_with(Encounter.NPC):
		return fighter.substr(Encounter.NPC.length())
	return fighter


## Plays the turn log `turns` (CombatState.turns) on the markers drawn now
## (M17.3). Emits the view's replay_step(i) as each entry starts and
## replay_done at the end. The camera leaves the player for the replay and
## comes back after it.
func replay(turns: Array) -> void:
	_replay_run += 1
	var run := _replay_run
	replaying = true
	var camera: Camera2D = _v.camera
	var overlay: CombatOverlay = _v.overlay
	var tree: SceneTree = _v.get_tree()
	var from := camera.global_position
	camera.top_level = true
	camera.global_position = from
	for i in turns.size():
		var t: Dictionary = turns[i]
		_v.replay_step.emit(i)
		var id := unit_of(String(t["id"]))
		var node := _unit_node(id)
		if node == null:
			continue
		await _pan(node.position).finished
		if run != _replay_run:
			return
		var cell: Vector2i = _v.cell_at(node.global_position)
		overlay.mark_active(cell)
		for to: Vector2i in t["path"]:
			var dir := AnimDiff.dir_of(to - cell)
			var old := node.position
			node.position = ViewArt.cell_center(to)
			_glide(node, id, old - node.position, dir)
			if _is_monster(id):
				_v.monster_facing[id] = dir
			cell = to
			overlay.mark_active(cell)
			_pan(node.position)
			await tree.create_timer(STEP_TIME).timeout
			if run != _replay_run:
				return
		if t.has("cells"):  # M17.5: the tiles of a spell light up while it hits
			var burst: Array[Vector2i] = []
			burst.assign(t["cells"])
			overlay.show_burst(burst)
		for s: Dictionary in t["strikes"]:
			var hit := _unit_node(unit_of(String(s["target"])))
			if hit == null:
				continue
			var hit_cell: Vector2i = _v.cell_at(hit.global_position)
			var dir := AnimDiff.dir_of(hit_cell - cell)
			_blow_sounds(id, unit_of(String(s["target"])), s)
			if not bool(s.get("ranged", false)):
				var swinging := _sprite_of(node)
				if swinging != null:
					swinging.attack(dir)
				else:
					_lunge(node, dir)
			if _is_monster(id):
				_v.monster_facing[id] = dir
			if bool(s["hit"]):
				_flash(hit)
				_number(hit.position, int(s["damage"]), hit == _v.player)
			await tree.create_timer(BLOW_TIME).timeout
			if run != _replay_run:
				return
		if t.has("cells"):
			overlay.show_burst([] as Array[Vector2i])
		await tree.create_timer(REPLAY_PAUSE).timeout
		if run != _replay_run:
			return
	_end_replay()
	_v.replay_done.emit()


## The sounds of one blow in a replay: a swing (not for a throw), then the
## hit and the voice of a hurt monster.
func _blow_sounds(by: String, target: String, s: Dictionary) -> void:
	if _v.audio == null:
		return
	var events: Array = []
	if not bool(s.get("ranged", false)):
		events.append({"type": AnimDiff.SWING, "id": by, "dir": "s"})
	if bool(s["hit"]):
		events.append({"type": AnimDiff.HIT, "id": target, "amount": int(s["damage"])})
	var cues := SoundCues.from_events(_v.audio, events, _v._last.get("units", {}))
	if not cues.is_empty():
		_v.sounds.emit(cues)


## Ends a replay at once (a key or a click during it). No replay_done.
func skip_replay() -> void:
	if not replaying:
		return
	_replay_run += 1
	_end_replay()


func _end_replay() -> void:
	replaying = false
	if _cam_tween != null and _cam_tween.is_valid():
		_cam_tween.kill()
	var overlay: CombatOverlay = _v.overlay
	overlay.clear_active()
	overlay.show_burst([] as Array[Vector2i])
	var camera: Camera2D = _v.camera
	camera.top_level = false
	camera.position = Vector2.ZERO
	camera.reset_smoothing()


## Moves the camera to `at` (map space). Returns the tween (await its
## `finished`); a newer pan stops an older one.
func _pan(at: Vector2) -> Tween:
	if _cam_tween != null and _cam_tween.is_valid():
		_cam_tween.kill()
	var camera: Camera2D = _v.camera
	_cam_tween = camera.create_tween()
	_cam_tween.tween_property(camera, "global_position", _v.to_global(at), CAMERA_TIME)
	return _cam_tween


## The marker of a unit: the player, an NPC or a monster (null = none).
func _unit_node(id: String) -> Node2D:
	if id == AnimDiff.PLAYER:
		return _v.player
	var n := (_v.npcs as Node2D).get_node_or_null(NodePath(id)) as Node2D
	return n if n != null else (_v.monsters as Node2D).get_node_or_null(NodePath(id)) as Node2D


static func _is_monster(id: String) -> bool:
	return id.begins_with("m") and id.substr(1).is_valid_int()


## The CharacterSprite of a marker, or null (a square).
func _sprite_of(node: Node2D) -> CharacterSprite:
	if node == _v.player:
		return _v.look
	if node == null:
		return null
	for c in node.get_children():
		if c is CharacterSprite:
			return c
	return null


## A marker glides one step: its sprite walks from `from` (old cell minus new
## cell, px); its squares, label and bar slide.
func _glide(node: Node2D, id: String, from: Vector2, dir: String) -> void:
	var t: Tween = null
	for c in node.get_children():
		if c is CharacterSprite:
			var s: CharacterSprite = c
			s.half = int(_halves.get(id, 0))
			s.walk(dir, from, STEP_TIME)
			_halves[id] = s.half
		elif (c is Control or c is Node2D) and not c is Camera2D:
			if t == null:
				t = node.create_tween().set_parallel(true)
			var base: Vector2 = c.position
			c.position = base + from
			t.tween_property(c, "position", base, STEP_TIME)


## A square marker lunges toward `dir` and back.
func _lunge(node: Node2D, dir: String) -> void:
	var to := Vector2(PlayerState.DIRS.get(dir, Vector2i.ZERO)) * LUNGE
	var t := node.create_tween().set_parallel(true)
	for c in node.get_children():
		if (c is Control or c is Node2D) and not c is Camera2D:
			var base: Vector2 = c.position
			t.tween_property(c, "position", base + to, LUNGE_TIME / 2.0)
			t.tween_property(c, "position", base, LUNGE_TIME / 2.0).set_delay(LUNGE_TIME / 2.0)


## A red flash on a hit unit (its sprite, else the whole marker).
func _flash(node: Node2D) -> void:
	var item: CanvasItem = _sprite_of(node)
	if item == null:
		item = node if node != _v.player else _v.body
	item.modulate = HIT_TINT
	item.create_tween().tween_property(item, "modulate", Color.WHITE, FLASH_TIME)


## "-3" over a unit at `at`; it rises and fades (red when you are hurt).
func _number(at: Vector2, amount: int, you: bool) -> void:
	var label := Label.new()
	label.text = "-%d" % amount
	label.add_theme_font_size_override("font_size", ViewArt.NAME_FONT_SIZE)
	label.add_theme_color_override("font_color", HURT_YOU_COLOR if you else HURT_OTHER_COLOR)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.9))
	label.add_theme_constant_override("outline_size", 8)
	label.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	label.scale = Vector2.ONE / ViewArt.TEXT_SCALE
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	(_v.fx as Node2D).add_child(label)
	var size := label.get_minimum_size() / ViewArt.TEXT_SCALE
	label.position = at + Vector2(-size.x / 2.0, -CharacterSprite.HEAD - size.y)
	var t := label.create_tween().set_parallel(true)
	t.tween_property(label, "position:y", label.position.y - NUMBER_RISE, NUMBER_TIME)
	t.tween_property(label, "modulate:a", 0.0, NUMBER_TIME).set_ease(Tween.EASE_IN)
	t.chain().tween_callback(label.queue_free)


## A gone monster on its old cell: its sprite falls (the hurt frames) and
## fades; with no sheet, a copy of its square shrinks and fades.
func _fade_out(cell: Vector2i, type: String, dir: String = "s") -> void:
	var ghost := Node2D.new()
	ghost.name = "gone"
	ghost.position = ViewArt.cell_center(cell)
	var sprite := CharacterSprite.make(_v.monster_look(type))
	if sprite != null:
		sprite.pose(dir)
		ghost.add_child(sprite)
	else:
		ViewArt.square(ghost, 5 * U, ViewMarkers.RING)
		ViewArt.square(ghost, 4 * U, Color.html(_v.enemies.get(type, {}).get("color", "#ff00ff")))
	(_v.fx as Node2D).add_child(ghost)
	var t := ghost.create_tween()
	if sprite != null:
		sprite.fall(CharacterSprite.FALL_TIME)
		t.tween_interval(CharacterSprite.FALL_TIME)
		t.tween_property(ghost, "modulate:a", 0.0, GONE_TIME)
	else:
		t.set_parallel(true)
		t.tween_property(ghost, "scale", Vector2(0.3, 0.3), GONE_TIME)
		t.tween_property(ghost, "modulate:a", 0.0, GONE_TIME)
		t = t.chain()
	t.tween_callback(ghost.queue_free)
