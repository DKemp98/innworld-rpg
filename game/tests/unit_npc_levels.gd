extends GutTest
## NPC levels at low detail (M25.0, ADR 0038) on toy data. Toy curve: level
## L → L+1 costs 100 * 2^(total level - 1); the toy capstone is level 3.
## Test rules: unknown_level 1, daily_xp 50, event_xp 100.


func _npc(classes: Array, alive: bool = true, book: int = 0) -> Dictionary:
	var n := ToyCanon.npc(["human"], alive)
	n["classes"] = classes
	if book > 0:
		n["canon_ref"] = {"book": book, "chapter": "x", "confidence": "guess"}
	return n


func _cls(name: String, level: Variant) -> Dictionary:
	return {"name": name, "level": level}


func _db(npcs: Dictionary, events: Dictionary = {}, rank: Dictionary = {}) -> DataDb:
	var d := ToyData.db()
	d.rules["npc"]["levels"] = {"unknown_level": 1, "daily_xp": 50, "event_xp": 100}
	d.canon = CanonDb.from_dicts(npcs, {}, events, rank)
	assert_eq(d.canon.errors, [] as Array[String])
	return d


func _gs(d: DataDb) -> GameState:
	return GameState.new_game(5, d)


func _held(gs: GameState, npc: String, cls: String) -> Dictionary:
	return gs.world.npc_levels.get(npc, {}).get(cls, {})


func test_known_and_unknown_canon_levels() -> void:
	var d := _db({"relc": _npc([_cls("[Spearmaster]", 2), _cls("[Sergeant]", null)])})
	var gs := _gs(d)
	var got := NpcLevels.classes_of(gs, d, "relc")
	assert_eq(got.size(), 2)
	assert_eq(got[0], {"name": "[Spearmaster]", "level": 2, "known": true, "gain": 0})
	assert_eq(got[1], {"name": "[Sergeant]", "level": 1, "known": false, "gain": 0}, "unknown = unknown_level")
	assert_eq(NpcLevels.total_level(gs, d, "relc"), 3)
	assert_eq(NpcLevels.classes_of(gs, d, "nobody").size(), 0)


func test_daily_xp_levels_a_low_npc_by_the_player_curve() -> void:
	var d := _db({"kid": _npc([_cls("[Cook]", 1)])})
	var gs := _gs(d)
	Director.run(gs, d, 1)
	assert_eq(_held(gs, "kid", "[Cook]"), {"gain": 0, "xp": 50.0})
	Director.run(gs, d, 2)
	assert_eq(_held(gs, "kid", "[Cook]"), {"gain": 1, "xp": 0.0}, "100 XP buys level 2")
	assert_eq(NpcLevels.classes_of(gs, d, "kid")[0]["level"], 2)


func test_xp_is_split_and_the_cost_follows_the_total_level() -> void:
	var d := _db({"twin": _npc([_cls("[Cook]", 1), _cls("[Guard]", 1)])})
	var gs := _gs(d)
	Director.run(gs, d, 8)
	# 25 XP a day each; total level 2 costs 200: [Cook] levels on day 8, then
	# [Guard] needs 400 (total level 3).
	assert_eq(_held(gs, "twin", "[Cook]"), {"gain": 1, "xp": 0.0})
	assert_eq(_held(gs, "twin", "[Guard]"), {"gain": 0, "xp": 200.0})


func test_a_capstone_waits_until_a_canon_event_tests_the_npc() -> void:
	var events := {"e.big_dinner": ToyCanon.event(11, 11, {
		"roles": {"chef": ToyCanon.role(["chef"], [])}, "requires": ToyCanon.req(["chef"])})}
	var d := _db({"chef": _npc([_cls("[Cook]", 2)])}, events)
	var gs := _gs(d)
	Director.run(gs, d, 10)
	assert_eq(_held(gs, "chef", "[Cook]"), {"gain": 0, "xp": 500.0}, "level 3 is a capstone: XP builds")
	Director.run(gs, d, 11)
	# 500 + 50 + 100 = 650; the key opens level 3 (200), level 4 costs 400 (total 3).
	assert_eq(gs.world.status("e.big_dinner"), Director.DONE)
	assert_eq(_held(gs, "chef", "[Cook]"), {"gain": 2, "xp": 50.0}, "key used up")


func test_an_early_key_is_kept_until_the_xp_fills() -> void:
	var events := {"e.small_dinner": ToyCanon.event(1, 1, {
		"roles": {"chef": ToyCanon.role(["chef"], [])}, "requires": ToyCanon.req(["chef"])})}
	var d := _db({"chef": _npc([_cls("[Cook]", 2)])}, events)
	var gs := _gs(d)
	Director.run(gs, d, 1)
	assert_eq(_held(gs, "chef", "[Cook]"), {"gain": 0, "xp": 150.0, "key": true}, "150 < 200: key waits")
	Director.run(gs, d, 2)
	assert_eq(_held(gs, "chef", "[Cook]"), {"gain": 1, "xp": 0.0}, "200: level 3 with the key")


func test_an_event_gives_xp_but_no_key_below_a_capstone() -> void:
	var events := {"e.chat": ToyCanon.event(1, 1, {
		"roles": {"guest": ToyCanon.role(["kid"], [])}, "requires": ToyCanon.req(["kid"])})}
	var d := _db({"kid": _npc([_cls("[Cook]", 1)])}, events)
	var gs := _gs(d)
	Director.run(gs, d, 1)
	# 150 XP: level 2 (100), then 50 toward the capstone level 3; no key kept.
	assert_eq(_held(gs, "kid", "[Cook]"), {"gain": 1, "xp": 50.0})


func test_dead_and_classless_npcs_never_grow() -> void:
	var d := _db({
		"ghost": _npc([_cls("[Mage]", 1)], false),
		"ryoka": _npc([]),
		"guard": _npc([_cls("[Guard]", 1)]),
	})
	var gs := _gs(d)
	Director.run(gs, d, 1)
	gs.world.set_alive("guard", false)
	Director.run(gs, d, 6)
	assert_false(gs.world.npc_levels.has("ghost"), "dead at the start")
	assert_false(gs.world.npc_levels.has("ryoka"), "no class, no levels")
	assert_eq(_held(gs, "guard", "[Guard]"), {"gain": 0, "xp": 50.0}, "stops when killed")


func test_a_later_book_npc_starts_on_its_books_first_day() -> void:
	var events := {"e.b1": ToyCanon.event(1, 1), "e.b2": ToyCanon.event(5, 6)}
	var rank := {"e.b1": [1, 1, 1], "e.b2": [2, 1, 1]}
	var d := _db({"newcomer": _npc([_cls("[Mage]", 1)], true, 2), "local": _npc([_cls("[Cook]", 1)], true, 1)},
			events, rank)
	assert_eq(d.canon.book_start, {1: 1, 2: 5})
	var gs := _gs(d)
	Director.run(gs, d, 4)
	assert_false(gs.world.npc_levels.has("newcomer"))
	assert_true(gs.world.npc_levels.has("local"))
	Director.run(gs, d, 5)
	assert_eq(_held(gs, "newcomer", "[Mage]"), {"gain": 0, "xp": 50.0})


func test_the_total_cap_stops_npc_levels() -> void:
	var d := _db({"kid": _npc([_cls("[Cook]", 1)])})
	d.rules["levels"]["total_cap"] = 1
	var gs := _gs(d)
	Director.run(gs, d, 6)
	assert_eq(_held(gs, "kid", "[Cook]"), {"gain": 0, "xp": 300.0})


func test_npc_levels_survive_save_and_load() -> void:
	var d := _db({"chef": _npc([_cls("[Cook]", 2)])})
	var gs := _gs(d)
	Director.run(gs, d, 3)
	gs.world.npc_levels["chef"]["[Cook]"]["key"] = true
	gs.world.npc_levels["chef"]["[Cook]"]["xp"] = 12.345678901
	var back := GameState.from_json(gs.to_json())
	assert_eq(back.world.npc_levels, gs.world.npc_levels)
	assert_eq(back.to_json(), gs.to_json())


func test_a_v20_save_loads_with_no_npc_levels() -> void:
	var d := _db({"kid": _npc([_cls("[Cook]", 1)])})
	var gs := _gs(d)
	Director.run(gs, d, 1)
	var data := gs.to_dict()
	(data["world"] as Dictionary).erase("npc_levels")
	data["save_version"] = 20
	var migrated := SaveMigrations.migrate(data)
	assert_eq(int(migrated["save_version"]), GameState.SAVE_VERSION)
	assert_eq(migrated["world"]["npc_levels"], {})
	var back := GameState.from_dict(migrated)
	Director.run(back, d, 2)
	assert_eq(_held(back, "kid", "[Cook]"), {"gain": 0, "xp": 50.0}, "grows from the next night")


func test_same_seed_same_npc_levels() -> void:
	var d := _db({"a": _npc([_cls("[Cook]", 1), _cls("[Guard]", null)]), "b": _npc([_cls("[Mage]", 3)])})
	var one := _gs(d)
	var two := _gs(d)
	Director.run(one, d, 9)
	Director.run(two, d, 9)
	assert_eq(one.world.npc_levels, two.world.npc_levels)
