## Static art helpers of the world view (M26.1, ADR 0041): cell size, sheet
## files, tile sets, object art, and small node makers (a square, a name
## label, a polygon, a sheet region). No state and no link back to WorldView,
## so WorldView and its helpers (ViewMap, ViewMarkers, ViewEffects) all use it
## with no script cycle. WorldView passes its public names on to these.
class_name ViewArt
extends RefCounted

const TILE := 32
## Old 16 px sizes are scaled by this.
const U := TILE / 16
const SHEET_PATH := "res://assets/tiles/%s.png"
const OBJECT_SHEET_PATH := "res://assets/objects/%s.png"
const OBJECT_ART_PATH := "res://data/objects.json"
## Name and number font size: two times Pixel Operator's 16 px grid (M15.0).
## Names are drawn this many times larger than they show (about 11 px), then
## scaled down, so they stay sharp under the camera zoom.
const NAME_FONT_SIZE := 32
const TEXT_SCALE := 3


## The file of an art sheet: game/assets/tiles/<name>.png, else
## game/assets/objects/<name>.png; "" when neither exists.
static func sheet_path(sheet_name: String) -> String:
	if sheet_name == "":
		return ""
	for f: String in [SHEET_PATH, OBJECT_SHEET_PATH]:
		if ResourceLoader.exists(f % sheet_name):
			return f % sheet_name
	return ""


## data/objects.json "kinds" ({} when the file is missing or broken).
static func load_object_art(path: String = OBJECT_ART_PATH) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}
	var d: Variant = JSON.parse_string(FileAccess.get_file_as_string(path))
	if not d is Dictionary or not (d as Dictionary).get("kinds", {}) is Dictionary:
		return {}
	return d["kinds"]


## The art of a map object: {"sheet", "region": Rect2 (pixels, frame 0),
## "frames"}, or {} when its kind has no art (it is drawn as a square).
static func object_look(o: Dictionary, kinds: Dictionary, winter: bool = false) -> Dictionary:
	var art: Variant = kinds.get(String(o.get("kind", "")), {})
	if not art is Dictionary or sheet_path(String(art.get("sheet", ""))) == "":
		return {}
	var r: Variant = art["winter_region"] if winter and art.has("winter_region") else art.get("region")
	if not r is Array or (r as Array).size() != 4:
		return {}
	return {"sheet": String(art["sheet"]), "region": Rect2(r[0], r[1], r[2], r[3]),
		"frames": maxi(int(art.get("frames", 1)), 1)}


static func cell_center(cell: Vector2i) -> Vector2:
	return Vector2(cell * TILE) + Vector2(TILE, TILE) / 2.0


## The art cell of a tile with more than one look, picked by map position
## (the same cell every time; no randomness).
static func pick_cell(cells: Array, cell: Vector2i) -> Vector2i:
	var h := absi((cell.x * 73856093) ^ (cell.y * 19349663))
	return cells[h % cells.size()]


## The sprite (or winter sprite) entry of a tile def, {} when none.
static func sprite_def(def: Dictionary, winter: bool, key: String = "sprite") -> Dictionary:
	if winter and def.has("winter_" + key):
		return def["winter_" + key]
	return def.get(key, {})


## One atlas row, one tile per tiles.json entry (file order). Tiles you
## cannot walk on get a darker edge. Fills `atlas_out` with id → coords.
## With `winter`, a tile's "winter_color" is used where it has one.
## Tiles with a sprite whose sheet exists also get an atlas source per sheet;
## `sprites_out` gets id → {"source", "cells"} for them.
static func make_tile_set(tile_defs: Dictionary, atlas_out: Dictionary, winter: bool = false,
		sprites_out: Dictionary = {}) -> TileSet:
	var ids := tile_defs.keys()
	var img := Image.create(TILE * maxi(ids.size(), 1), TILE, false, Image.FORMAT_RGBA8)
	for i in ids.size():
		var def: Dictionary = tile_defs[ids[i]]
		var color := Color.html(def["winter_color"] if winter and def.has("winter_color") else def["color"])
		var cell := Rect2i(i * TILE, 0, TILE, TILE)
		if def["walk"]:
			img.fill_rect(cell, color)
		else:
			img.fill_rect(cell, color.darkened(0.35))
			img.fill_rect(cell.grow(-2), color)
		atlas_out[ids[i]] = Vector2i(i, 0)
	var source := TileSetAtlasSource.new()
	source.texture = ImageTexture.create_from_image(img)
	source.texture_region_size = Vector2i(TILE, TILE)
	var ts := TileSet.new()
	ts.tile_size = Vector2i(TILE, TILE)
	ts.add_source(source, 0)
	for i in ids.size():
		source.create_tile(Vector2i(i, 0))
	var sheets := {}
	for id in ids:
		var sp := sprite_def(tile_defs[id], winter)
		if sp.is_empty() or sheet_path(String(sp["sheet"])) == "":
			continue
		if not sheets.has(sp["sheet"]):
			var s := TileSetAtlasSource.new()
			s.texture = load(sheet_path(String(sp["sheet"])))
			s.texture_region_size = Vector2i(TILE, TILE)
			sheets[sp["sheet"]] = ts.add_source(s)
		var src: TileSetAtlasSource = ts.get_source(sheets[sp["sheet"]])
		var cells: Array[Vector2i] = []
		for c: Array in sp["cells"]:
			var v := Vector2i(int(c[0]), int(c[1]))
			if not src.has_tile(v):
				src.create_tile(v)
			cells.append(v)
		sprites_out[id] = {"source": sheets[sp["sheet"]], "cells": cells}
	return ts


## A sprite of a region (pixels) of a sheet, bottom-centred on a cell whose
## centre is the sprite's position.
static func region_sprite(sheet: String, region: Rect2) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = load(sheet_path(sheet))
	s.region_enabled = true
	s.region_rect = region
	s.centered = false
	s.offset = Vector2(-region.size.x / 2.0, TILE / 2.0 - region.size.y)
	return s


## A new sprite of a tile's prop (a tree, a rock), bottom-centred on (0, 0);
## null when the tile has no prop art.
static func tile_prop(tile_defs: Dictionary, tile: String, winter: bool) -> Sprite2D:
	var def: Dictionary = tile_defs.get(tile, {})
	var p := sprite_def(def, winter, "prop")
	if p.is_empty() or sheet_path(String(p["sheet"])) == "":
		return null
	var r: Array = p["region"]
	return region_sprite(p["sheet"], Rect2(Vector2(int(r[0]), int(r[1])) * TILE,
			Vector2(int(r[2]), int(r[3])) * TILE))


## A square of half-width `half` centred on the marker.
static func square(marker: Node2D, half: float, color: Color) -> void:
	var r := ColorRect.new()
	r.position = Vector2(-half, -half)
	r.size = Vector2(half, half) * 2.0
	r.color = color
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	marker.add_child(r)


## A rectangle at `pos` (parent space) under `parent`.
static func rect(parent: Node, pos: Vector2, size: Vector2, color: Color) -> void:
	var r := ColorRect.new()
	r.position = pos
	r.size = size
	r.color = color
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(r)


## A filled polygon node.
static func poly(points: PackedVector2Array, color: Color) -> Polygon2D:
	var p := Polygon2D.new()
	p.polygon = points
	p.color = color
	return p


## A small sharp name label centred above a marker, its bottom `top` px
## above the marker's centre. Returns the label.
static func add_label(marker: Node2D, text: String, top: float = 5.0 * U) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", NAME_FONT_SIZE)
	label.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	label.add_theme_constant_override("outline_size", 6)
	label.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR
	label.scale = Vector2.ONE / TEXT_SCALE
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	marker.add_child(label)
	var size := label.get_minimum_size() / TEXT_SCALE
	label.position = Vector2(-size.x / 2.0, -top - size.y)
	return label
