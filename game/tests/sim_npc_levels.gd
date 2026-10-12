extends GutTest
## NPC levels on the real canon (M25.0, ADR 0038): the director runs Books 1 – 6
## (to day 129) with no player, and the canon NPCs grow at low detail.

const LAST_DAY := 129

var _db: DataDb
var _gs: GameState


func before_all() -> void:
	_db = DataDb.load_dir()
	_gs = GameState.new(7)
	Director.run(_gs, _db, LAST_DAY)


func _gain(npc: String) -> int:
	var sum := 0
	for c: Dictionary in NpcLevels.classes_of(_gs, _db, npc):
		sum += int(c["gain"])
	return sum


func test_the_real_rules_have_npc_levels() -> void:
	var r: Dictionary = _db.rules["npc"]["levels"]
	assert_gt(int(r["unknown_level"]), 0)
	assert_gt(float(r["daily_xp"]), 0.0)
	assert_gt(float(r["event_xp"]), 0.0)


func test_the_books_start_in_order_of_their_first_events() -> void:
	assert_eq(int(_db.canon.book_start[1]), 1)
	for book in range(2, 8):
		assert_true(_db.canon.book_start.has(book), "book %d" % book)
	assert_eq(_db.canon.first_day_of("relc"), 1)


func test_npcs_with_no_class_never_level() -> void:
	# Ryoka never levels; Dragons cannot level (1.06).
	for npc in ["ryoka_griffin", "cave_dragon"]:
		assert_eq(_db.canon.npcs[npc]["classes"], [], npc)
		assert_false(_gs.world.npc_levels.has(npc), npc)


func test_canon_npcs_grow_slowly() -> void:
	var grew := 0
	var most := 0
	for npc: String in _gs.world.npc_levels:
		var g := _gain(npc)
		grew += 1 if g > 0 else 0
		most = maxi(most, g)
	gut.p("NPCs with levels: %d; grew: %d; most levels: %d" % [_gs.world.npc_levels.size(), grew, most])
	assert_gt(grew, 20, "many NPCs gain a level in 129 days")
	assert_lt(most, 20, "nobody runs away")
	assert_eq(_gain("relc"), 0, "a total level of 57 costs far more than 129 days give")


func test_a_book7_npc_has_not_started_yet() -> void:
	var found := ""
	for npc: String in _db.canon.npcs:
		if _db.canon.first_day_of(npc) > LAST_DAY and not (_db.canon.npcs[npc]["classes"] as Array).is_empty():
			found = npc
			break
	assert_ne(found, "", "Book 7 has an NPC with a class")
	assert_false(_gs.world.npc_levels.has(found), found)


func test_class_levels_never_pass_the_total_cap() -> void:
	var cap := int(_db.rules["levels"]["total_cap"])
	for npc: String in _gs.world.npc_levels:
		var known := NpcLevels.classes_of(_gs, _db, npc).all(
				func(c: Dictionary) -> bool: return int(c["gain"]) >= 0)
		assert_true(known, npc)
		assert_true(NpcLevels.total_level(_gs, _db, npc) <= maxi(cap, _base_total(npc)), npc)


## The NPC's total level at the start (canon or unknown_level), which may be over the cap.
func _base_total(npc: String) -> int:
	return NpcLevels.total_level(_gs, _db, npc) - _gain(npc)
