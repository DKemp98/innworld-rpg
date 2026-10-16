extends GutTest
## M28.4 on the real Book 8 data (5.27, 5.28, 5.29, days 155 - 156): the Goblin Bronze team, the Silver teams, the
## bridge, the play brawl, Ilvriss's Drake boycott (rules.inn.race_boycott), the six-team dive, the Shield Spider
## nest, the rift rescue and the Antinium tunnel secret. Events only: no stage, no hook, no xp_window.
## Slept to day 154 once (before_all).

const SEED := 20261016
const CHAPTERS := ["5.27", "5.28", "5.29"]
const BOYCOTT := "wandering_inn.drake_boycott"

var _db: DataDb
var _base := ""


func before_all() -> void:
	_db = DataDb.load_dir()
	assert_eq(_db.errors, [] as Array[String])
	var gs := GameState.new_game(SEED, _db)
	ToyCanon.sleep_through(gs, _db, 154)
	_base = gs.to_json()


func _through(day: int) -> GameState:
	var gs := GameState.from_json(_base)
	ToyCanon.sleep_through(gs, _db, day)
	assert_eq(gs.clock.day(), day + 1)
	return gs


## The 5.27 - 5.29 canon events. Alt events (M23.6) are left out.
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


func _drake_weight(gs: GameState) -> float:
	var races: Dictionary = _db.rules["inn"]["patron_races"]
	return float(Guests.race_weights(gs, _db)[races.keys().find("drake")])


func test_the_batch_is_events_only_and_in_order() -> void:
	var ids := _batch_ids()
	assert_eq(ids.size(), 27)
	for id: String in ids:
		var ev: Dictionary = _db.canon.events[id]
		assert_false(ev.has("stage"), id)
		assert_false(ev.has("hooks"), id)
		assert_false(ev.has("xp_window"), id)
		assert_false(ev["effects"].has("kill"), id)
		assert_ne(ev["location"], "raskghar_camp", id)
		assert_true(int(ev["window"]["earliest"]) >= 155 and int(ev["window"]["latest"]) <= 157, id)
		for dep: String in ev["depends_on"]:
			assert_true(_db.canon.events.has(dep), dep)
			assert_true(int(_db.canon.events[dep]["window"]["earliest"]) <= int(ev["window"]["earliest"]), id + " after " + dep)


func test_day_155_bronze_goblins_the_bridge_and_the_brawl() -> void:
	var gs := GameState.from_json(_base)
	assert_true(gs.flags.has("wandering_inn.bridge_to_liscor_being_built"))
	assert_false(gs.flags.has(BOYCOTT))
	ToyCanon.sleep_through(gs, _db, 155)
	_has_all(gs, ["redfang.bronze_team_registered", "redfang.accept_bronze_rank", "pride_of_kelia.at_the_inn",
			"gemhammer.at_the_inn", "erin.backs_silver_rank_dives", "wandering_inn.calruz_reward_posted",
			"wandering_inn.bridge_to_liscor_finished", "horns_of_hammerad.will_enter_the_dungeon",
			"wandering_inn.play_brawl", "ilvriss.started_the_play_brawl", BOYCOTT])
	assert_false(gs.flags.has("wandering_inn.bridge_to_liscor_being_built"))
	assert_false(gs.flags.has("horns_of_hammerad.entered_the_dungeon"))


func test_the_boycott_cuts_drake_patrons() -> void:
	var entries: Array = _db.rules["inn"].get("race_boycott", [])
	var factor := -1.0
	for b: Dictionary in entries:
		if b["flag"] == BOYCOTT and b["race"] == "drake":
			factor = float(b["factor"])
	assert_true(factor > 0.0 and factor < 1.0, "rules.inn.race_boycott has the Drake entry")
	assert_eq(Guests.validate(_db), [] as Array[String])
	var before := _drake_weight(GameState.from_json(_base))
	var after := _drake_weight(_through(155))
	assert_almost_eq(after, before * factor, 0.0001)


func test_day_156_the_dive_the_nest_and_the_antinium_secret() -> void:
	var gs := _through(156)
	_has_all(gs, ["zevara.paid_the_inn_for_the_brawl", "zevara.rules_the_play_lawful", "griffon_hunt.entered_the_dungeon",
			"halfseekers.entered_the_dungeon", "gemhammer.dove_the_rift", "pride_of_kelia.dove_the_rift",
			"horns_of_hammerad.entered_the_dungeon", "silver_swords.entered_the_dungeon",
			"dungeon.masked_swordswoman_seen", "dungeon.shield_spider_nest_found", "dungeon.shield_spider_nest_thinned",
			"horns_of_hammerad.survived_the_spider_wave", "wandering_inn.runs_dungeon_rescue_boats",
			"dungeon.antinium_entrance_found", "liscor.antinium_dungeon_entrance_known",
			"horns_of_hammerad.leak_the_antinium_entrance", "wandering_inn.dive_survivors_party", BOYCOTT])
	for id: String in ["erin_solstice", "earlia", "nailren", "falene_skystrall", "typhenous", "jelaqua", "ceria_springwalker",
			"pisces", "ksmvr", "belgrade", "ilvriss", "headscratcher"]:
		assert_true(gs.world.is_alive(_db.canon, id), id)


func test_the_rain_and_flood_go_on() -> void:
	var gs := _through(156)
	assert_true(gs.flags.has("izril.rains"), "the rain does not stop in 5.27 - 5.29")
	assert_true(gs.flags.has("izril.flood"), "the flood does not stop in 5.27 - 5.29")
	for id: String in _batch_ids():
		var fx: Dictionary = _db.canon.events[id]["effects"]
		for f: String in fx.get("clear_flags", []):
			assert_false(f.begins_with("izril."), id)


func test_no_level_records_and_no_masked_swordswoman_record() -> void:
	for ch: String in CHAPTERS:
		var doc: Variant = JSON.parse_string(FileAccess.get_file_as_string("res://data/canon/book8/chapters/%s.json" % ch))
		assert_true(doc is Dictionary, ch)
		for s: Dictionary in doc["system"]:
			assert_ne(s["who"], "ryoka_griffin", "Ryoka never levels")
		assert_eq(doc["system"].size(), 0, ch + ": no level changes in 5.27 - 5.29")
	for id: String in _batch_ids():
		for role: String in _db.canon.events[id]["roles"]:
			assert_false(_db.canon.events[id]["roles"][role]["prefer"].has("ryoka_griffin"), id)
	for npc: String in _db.canon.npcs:
		assert_false(npc.contains("masked"), npc)
	assert_eq(_db.canon.npcs["ryoka_griffin"].get("classes", []), [])
