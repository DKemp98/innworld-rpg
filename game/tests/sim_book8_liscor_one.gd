extends GutTest
## M28.3 on the real Book 8 data (5.24 L, 5.25 L, 5.26 L, days 144 - 154): the inn mended, the bridge ordered, the
## Heartflame lease, Lyonette loses [Princess], Pawn's week of visits, the quarrel, Krshia's plan, the ball in the Hive,
## [Worldly Princess] 11. Events only: no stage, no hook, no xp_window. Slept to day 143 once (before_all).

const SEED := 20261016
const CHAPTERS := ["5.24L", "5.25L", "5.26L"]

var _db: DataDb
var _base := ""


func before_all() -> void:
	_db = DataDb.load_dir()
	assert_eq(_db.errors, [] as Array[String])
	var gs := GameState.new_game(SEED, _db)
	ToyCanon.sleep_through(gs, _db, 143)
	_base = gs.to_json()


func _through(day: int) -> GameState:
	var gs := GameState.from_json(_base)
	ToyCanon.sleep_through(gs, _db, day)
	assert_eq(gs.clock.day(), day + 1)
	return gs


## The 5.24L - 5.26L canon events. Alt events (M23.6) are left out.
func _batch_ids() -> Array[String]:
	var ids: Array[String] = []
	for id: String in _db.canon.events:
		var ref: Dictionary = _db.canon.events[id]["canon_ref"]
		if int(ref["book"]) == 8 and String(ref["chapter"]) in CHAPTERS and not _db.canon.alt_only.has(id):
			ids.append(id)
	return ids


func _has_all(gs: GameState, flags: Array) -> void:
	for f: String in flags:
		assert_true(gs.flags.has(f), f)


func test_the_batch_is_events_only_and_in_order() -> void:
	var ids := _batch_ids()
	assert_eq(ids.size(), 27)
	for id: String in ids:
		var ev: Dictionary = _db.canon.events[id]
		assert_false(ev.has("stage"), id)
		assert_false(ev.has("hooks"), id)
		assert_false(ev.has("xp_window"), id)
		assert_false(ev["effects"].has("kill"), id)
		assert_true(int(ev["window"]["earliest"]) >= 144 and int(ev["window"]["latest"]) <= 154, id)
		for dep: String in ev["depends_on"]:
			assert_true(_db.canon.events.has(dep), dep)
			assert_true(int(_db.canon.events[dep]["window"]["earliest"]) <= int(ev["window"]["earliest"]), id + " after " + dep)


func test_day_144_mends_the_inn_and_orders_the_bridge() -> void:
	var gs := GameState.from_json(_base)
	_has_all(gs, ["wandering_inn.windows_broken", "wandering_inn.watchtower_smashed"])
	ToyCanon.sleep_through(gs, _db, 144)
	_has_all(gs, ["wandering_inn.repaired_after_the_moths", "bird.back_in_his_watchtower", "jelaqua.new_drake_body",
			"wandering_inn.bridge_to_liscor_ordered", "heartflame.leased_to_halfseekers",
			"halfseekers.testing_the_heartflame_breastplate", "pawn.seeks_rainy_day_pastimes_for_the_hive"])
	for f: String in ["wandering_inn.windows_broken", "wandering_inn.watchtower_smashed", "jelaqua.body_broken"]:
		assert_false(gs.flags.has(f), f)
	assert_false(gs.flags.has("lyonette.lost_her_princess_class"))


func test_day_145_lyonette_loses_her_class_and_the_bridge_is_built() -> void:
	var gs := _through(145)
	_has_all(gs, ["apista.can_set_herself_aflame", "wandering_inn.new_staff_hired", "wandering_inn.bridge_to_liscor_being_built",
			"redfangs.guard_the_bridge_builders", "lyonette.lost_her_princess_class"])
	assert_false(gs.flags.has("lyonette.wept_for_her_lost_class"))


func test_days_146_to_151_pawns_week_and_the_quarrel() -> void:
	var gs := _through(146)
	_has_all(gs, ["lyonette.wept_for_her_lost_class", "pawn.knows_lyonette_lost_her_class", "antinium.a_soldier_won_at_chess"])
	ToyCanon.sleep_through(gs, _db, 151)
	_has_all(gs, ["pawn.brings_crafts_and_games_to_the_hive", "lyonette.shouted_at_pawn",
			"pawn.admitted_praying_for_lyonettes_class"])
	assert_false(gs.flags.has("pawn.visits_lyonette_every_day"), "the daily visits end with the quarrel")
	assert_false(gs.flags.has("lyonette.danced_with_pawn"))


func test_days_152_to_154_the_ball_and_the_worldly_princess() -> void:
	var gs := _through(154)
	_has_all(gs, ["pawn.uncurled", "krshia.advises_pawn_to_hold_a_ball", "pawn.held_a_ball_for_lyonette",
			"antinium.learn_to_waltz", "lyonette.princess_class_restored", "lyonette.is_a_worldly_princess",
			"lyonette.and_pawn_hold_hands"])
	for f: String in ["lyonette.lost_her_princess_class", "pawn.curled_up_in_despair", "painted_soldiers.hunger_strike_for_pawn"]:
		assert_false(gs.flags.has(f), f)
	for id: String in ["lyonette", "pawn", "erin_solstice", "krshia", "klbkch", "purple_smile", "yellow_splatters", "mrsha"]:
		assert_true(gs.world.is_alive(_db.canon, id), id)


func test_the_rain_and_flood_go_on() -> void:
	var gs := _through(154)
	assert_true(gs.flags.has("izril.rains"), "the rain does not stop in 5.24 - 5.26")
	assert_true(gs.flags.has("izril.flood"), "the flood does not stop in 5.24 - 5.26")
	for id: String in _batch_ids():
		var fx: Dictionary = _db.canon.events[id]["effects"]
		for f: String in fx.get("clear_flags", []):
			assert_false(f.begins_with("izril."), id)


func test_lyonettes_class_records() -> void:
	var by_chapter := {}
	for ch: String in CHAPTERS:
		var doc: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/canon/book8/chapters/%s.json" % ch))
		assert_true(doc is Dictionary, ch)
		by_chapter[ch] = doc["system"]
	var lost := false
	for s: Dictionary in by_chapter["5.24L"]:
		assert_eq(s["who"], "lyonette")
		if s["name"] == "[Princess] lost":
			lost = true
	assert_true(lost, "[Princess] lost in 5.24 L")
	var worldly := 0
	for s: Dictionary in by_chapter["5.26L"]:
		assert_eq(s["who"], "lyonette")
		if s["name"] == "[Worldly Princess]":
			worldly = int(s["level"])
	assert_eq(worldly, 11)
	for ch: String in CHAPTERS:
		for s: Dictionary in by_chapter[ch]:
			assert_ne(s["who"], "ryoka_griffin", "Ryoka never levels")
