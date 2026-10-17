extends GutTest
## M28.8 on the real Book 8 data (5.39, 5.40, 5.41, 5.42; days 161 - 162): Calruz breaks Ceria with a sacrifice,
## Ksmvr loses to Klbkch, the Free Antinium go into the dungeon, the Horns and the Gold-ranks dive and fail, the
## Redfangs go in with Cave Goblin guides, Erin feeds the Cave Goblins, Calruz shows Ceria the dungeon city.
## User choice: events only (no stage, no hook, no xp_window; raskghar_camp is not used).
## The game is slept to day 160 once (before_all); each test starts from a copy.

const SEED := 20261016
const CHAPTERS := ["5.39", "5.40", "5.41", "5.42"]
const CAPTIVE := ["mrsha.taken_by_the_raskghar", "ceria.taken_by_the_raskghar", "calruz.revealed_as_the_raskghar_great_chieftain",
		"calruz.holds_ceria", "mrsha.caged_in_the_raskghar_camp"]

var _db: DataDb
var _base := ""


func before_all() -> void:
	_db = DataDb.load_dir()
	assert_eq(_db.errors, [] as Array[String])
	assert_eq(_db.canon.errors, [] as Array[String])
	var gs := GameState.new_game(SEED, _db)
	ToyCanon.sleep_through(gs, _db, 160)
	_base = gs.to_json()


func _at_end_of(day: int) -> GameState:
	var gs := GameState.from_json(_base)
	assert_eq(gs.clock.day(), 161)
	ToyCanon.sleep_through(gs, _db, day)
	return gs


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


func _system(chapter: String) -> Array:
	var f := FileAccess.open("res://data/canon/book8/chapters/%s.json" % chapter, FileAccess.READ)
	var doc: Dictionary = JSON.parse_string(f.get_as_text())
	return doc["system"]


func test_the_batch_is_events_only() -> void:
	var ids := _batch_ids()
	assert_eq(ids.size(), 41)
	var killed: Array[String] = []
	for id: String in ids:
		var ev: Dictionary = _db.canon.events[id]
		assert_false(ev.has("stage"), id + " has no stage")
		assert_false(ev.has("hooks"), id + " has no hook")
		assert_false(ev.has("xp_window"), id)
		assert_ne(ev["location"], "raskghar_camp", id)
		var e := int(ev["window"]["earliest"])
		assert_true(e >= 161 and int(ev["window"]["latest"]) <= 162, id)
		for dep: String in ev["depends_on"]:
			assert_true(_db.canon.events.has(dep), dep)
			assert_true(int(_db.canon.events[dep]["window"]["earliest"]) <= e, id + " after " + dep)
		for n: String in ev["effects"].get("kill", []):
			killed.append(n)
	assert_eq(killed, ["rebat"] as Array[String], "only Rebat is named dead (the Redfang dead have no records)")


func test_day_161_calruz_breaks_ceria_and_the_antinium_go_in() -> void:
	var gs := _at_end_of(161)
	_has_all(gs, CAPTIVE)
	_has_all(gs, ["calruz.learns_his_old_team_died", "raskghar.ritual_sacrifice_performed", "ceria.submits_to_calruz",
			"elirr.calls_mrsha_doombringer", "ksmvr.challenged_klbkch_and_lost", "free_antinium.dungeon_offensive_launched",
			"bird.searching_the_dungeon_alone", "pisces.knows_ceria_and_mrsha_are_alive", "yvlon.sleep_spelled_and_bound_by_falene",
			"redfang.accept_erins_rescue_request", "ilvriss.doubles_the_reward_for_missing_citizens"])
	assert_false(gs.world.is_alive(_db.canon, "rebat"), "Rebat is counted among the dead")
	assert_false(gs.flags.has("pisces.raised_new_bone_horrors"), "the dive waits for day 162")


func test_day_162_the_dive_fails_and_the_redfangs_find_the_camp() -> void:
	var gs := _at_end_of(162)
	_has_all(gs, ["pisces.raised_new_bone_horrors", "silver_teams.follow_the_horns_into_the_dungeon",
			"free_antinium.dungeon_offensive_broken", "halrac.forgives_bird", "adventurers.pull_out_for_the_day",
			"redfang.destroyed_a_raskghar_outpost", "erin.feeds_the_cave_goblins", "drassi.turned_the_crowd_with_gossip",
			"cave_goblins.know_tonights_raskghar_camp", "shorthilt.is_a_weapon_expert", "badarrow.is_a_sniper",
			"ceria.has_seen_the_dungeon_city", "dungeon.mother_of_graves_known", "calruz.halts_the_sacrifices",
			"raskghar.camp_struck_by_night"])
	for f: String in ["free_antinium.dungeon_offensive_launched", "bird.searching_the_dungeon_alone",
			"yvlon.sleep_spelled_and_bound_by_falene"]:
		assert_false(gs.flags.has(f), f + " is cleared")


func test_ceria_and_mrsha_stay_captive_and_calruz_lives() -> void:
	var gs := _at_end_of(162)
	_has_all(gs, CAPTIVE)
	_has_all(gs, ["calruz.struck_ceria_down", "calruz.suspects_ceria_of_treachery"])
	for n: String in ["calruz", "ceria_springwalker", "mrsha", "nokha", "elirr", "vakk", "klbkch", "ksmvr", "bird",
			"pisces", "yvlon_byres", "moore", "jelaqua", "halrac", "headscratcher", "numbtongue", "shorthilt", "badarrow",
			"rabbiteater", "pebblesnatch", "erin_solstice"]:
		assert_true(gs.world.is_alive(_db.canon, n), n)


func test_the_rain_and_flood_stay_on() -> void:
	var gs := _at_end_of(162)
	assert_true(gs.flags.has("izril.rains"), "it still rains in 5.39 - 5.42")
	assert_true(gs.flags.has("izril.flood"), "the flood is still up")


func test_level_records_show_the_redfang_gains() -> void:
	var seen := {}
	for ch: String in CHAPTERS:
		for s: Dictionary in _system(ch):
			assert_ne(s["who"], "ryoka_griffin", "Ryoka never levels")
			seen["%s %s" % [s["who"], s["name"]]] = s["level"]
	assert_eq(int(seen.get("shorthilt [Warrior]", -1)), 24)
	assert_eq(int(seen.get("badarrow [Archer]", -1)), 25)
	assert_eq(int(seen.get("rabbiteater [Warrior]", -1)), 19)
	assert_eq(int(seen.get("drassi [Gossip]", -1)), 17)
	for k: String in ["shorthilt [Weapon Expert]", "badarrow [Sniper]", "badarrow [Eagle Eyes]", "numbtongue [Electric Chords]",
			"ksmvr [Quick Slash]", "calruz [Gore Splash]"]:
		assert_true(seen.has(k), k)
