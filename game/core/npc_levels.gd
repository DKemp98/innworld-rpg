## NPC levels at low detail (M25.0, DESIGN §4.5, ADR 0038). Canon NPCs level
## through the same System as the player, once a day instead of per action:
##   - Each living NPC with classes (canon npcs.json "classes") gets
##     rules.npc.levels.daily_xp a day, and event_xp more on a day a canon event
##     that happened cast them by name. The XP is split evenly between the
##     NPC's classes (more classes, less XP each).
##   - The next level of any class costs Levels.xp_to_next(total level), with
##     the player's curve, capstones and total cap (M17.7).
##   - A capstone (10, 20, 30) needs a key. Being cast in a canon event while
##     a class is one level under a capstone gives the key (kept until the XP
##     fills, like the player's, ADR 0035): the event is the test.
##   - A canon level of null is not known; the System uses unknown_level.
##   - An NPC of a later book starts to grow on its book's first day
##     (CanonDb.first_day_of), so its canon level is right when it appears.
## Never random. The state lives in gs.world.npc_levels.
class_name NpcLevels
extends RefCounted


## Every class the NPC holds now, in data order:
## [{"name", "level", "known": canon level given, "gain": levels since the start}].
static func classes_of(gs: GameState, db: DataDb, npc: String) -> Array[Dictionary]:
	var out: Array[Dictionary] = []
	var held: Dictionary = gs.world.npc_levels.get(npc, {})
	var unknown := int(_rules(db).get("unknown_level", 1))
	for c: Dictionary in db.canon.npcs.get(npc, {}).get("classes", []):
		var cls := String(c["name"])
		var known: bool = c.get("level") != null
		var gain := int(held.get(cls, {}).get("gain", 0))
		var base := int(c["level"]) if known else unknown
		out.append({"name": cls, "level": base + gain, "known": known, "gain": gain})
	return out


## Sum of the NPC's class levels (unknown levels count as unknown_level).
## Never shown, like the player's.
static func total_level(gs: GameState, db: DataDb, npc: String) -> int:
	var sum := 0
	for c: Dictionary in classes_of(gs, db, npc):
		sum += int(c["level"])
	return sum


## One day of growth for every canon NPC. Director.run calls it after the
## day's canon events.
static func grow(gs: GameState, db: DataDb, day: int) -> void:
	var r := _rules(db)
	if r.is_empty():
		return
	var cast := _cast_on(gs, day)
	for npc: String in db.canon.npcs:
		var defs: Array = db.canon.npcs[npc].get("classes", [])
		if defs.is_empty() or not gs.world.is_alive(db.canon, npc) or day < db.canon.first_day_of(npc):
			continue
		var tested := cast.has(npc)
		var xp := float(r["daily_xp"]) + (float(r["event_xp"]) if tested else 0.0)
		_add_xp(gs, db, npc, xp / defs.size(), tested)


## Adds `xp` to each of the NPC's classes, gives keys if `tested`, then levels
## the classes up in data order.
static func _add_xp(gs: GameState, db: DataDb, npc: String, xp: float, tested: bool) -> void:
	var levels: Dictionary = db.rules["levels"]
	if not gs.world.npc_levels.has(npc):
		gs.world.npc_levels[npc] = {}
	var held: Dictionary = gs.world.npc_levels[npc]
	for c: Dictionary in db.canon.npcs[npc]["classes"]:
		var cls := String(c["name"])
		if not held.has(cls):
			held[cls] = {"gain": 0, "xp": 0.0}
		held[cls]["xp"] = float(held[cls]["xp"]) + xp
	for c: Dictionary in classes_of(gs, db, npc):
		var entry: Dictionary = held[c["name"]]
		if tested and Levels.is_capstone(int(c["level"]) + 1, levels):
			entry["key"] = true
		_level_up(gs, db, npc, c["name"], int(c["level"]))


## Spends a class's XP on levels, like Levels.level_up for the player.
static func _level_up(gs: GameState, db: DataDb, npc: String, cls: String, level: int) -> void:
	var levels: Dictionary = db.rules["levels"]
	var cap := int(levels.get("total_cap", 0))
	var entry: Dictionary = gs.world.npc_levels[npc][cls]
	while cap <= 0 or total_level(gs, db, npc) < cap:
		var capstone := Levels.is_capstone(level + 1, levels)
		if capstone and not entry.has("key"):
			return
		var need := _cost(gs, db, npc)
		if float(entry["xp"]) < need:
			return
		entry["xp"] = float(entry["xp"]) - need
		entry["gain"] = int(entry["gain"]) + 1
		level += 1
		if capstone:
			entry.erase("key")


static func _cost(gs: GameState, db: DataDb, npc: String) -> float:
	return Levels.xp_to_next(maxi(total_level(gs, db, npc), 1), db.rules["levels"])


## Named NPCs cast in a canon event that happened on `day` (history roles;
## "*" fillers are nobody in particular). npc → true.
static func _cast_on(gs: GameState, day: int) -> Dictionary:
	var out := {}
	for i in range(gs.world.history.size() - 1, -1, -1):
		var h: Dictionary = gs.world.history[i]
		if int(h["day"]) < day:
			break
		if int(h["day"]) != day or not Director.happened(String(h["outcome"])):
			continue
		for v: Variant in (h.get("roles", {}) as Dictionary).values():
			var npc := str(v) if v != null else ""
			if npc != "" and not npc.begins_with(Director.ANONYMOUS):
				out[npc] = true
	return out


static func _rules(db: DataDb) -> Dictionary:
	return db.rules.get("npc", {}).get("levels", {})
