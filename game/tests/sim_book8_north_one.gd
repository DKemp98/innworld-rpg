extends GutTest
## M28.2 on the real Book 8 data (5.21 E, 5.22 G, 5.23 G, days 143 - 148): Laken's nobles and Magnolia's offer,
## the night raid on the Goblin camp, Rags cut down, the harrying, Rags wakes, Lancrel falls, the burning raids.
## All off the map: no stage, no hook, no xp_window. Slept to day 142 once (before_all).

const SEED := 20261016

var _db: DataDb
var _base := ""


func before_all() -> void:
	_db = DataDb.load_dir()
	assert_eq(_db.errors, [] as Array[String])
	var gs := GameState.new_game(SEED, _db)
	ToyCanon.sleep_through(gs, _db, 141)
	_base = gs.to_json()


func _at_day(day: int) -> GameState:
	var gs := GameState.from_json(_base)
	if day > 142:
		ToyCanon.sleep_through(gs, _db, day - 1)
	assert_eq(gs.clock.day(), day)
	return gs


## The 5.21E - 5.23G canon events. Alt events (M23.6) are left out.
func _batch_ids() -> Array[String]:
	var ids: Array[String] = []
	for id: String in _db.canon.events:
		var ref: Dictionary = _db.canon.events[id]["canon_ref"]
		if int(ref["book"]) == 8 and String(ref["chapter"]) in ["5.21E", "5.22G", "5.23G"] and not _db.canon.alt_only.has(id):
			ids.append(id)
	return ids


func _has_all(gs: GameState, flags: Array) -> void:
	for f: String in flags:
		assert_true(gs.flags.has(f), f)


func test_the_batch_is_off_map_and_in_order() -> void:
	var ids := _batch_ids()
	assert_eq(ids.size(), 38)
	for id: String in ids:
		var ev: Dictionary = _db.canon.events[id]
		assert_false(ev.has("stage"), id)
		assert_false(ev.has("hooks"), id)
		assert_false(ev.has("xp_window"), id)
		assert_true(int(ev["window"]["earliest"]) >= 143 and int(ev["window"]["latest"]) <= 148, id)
		assert_false(ev["effects"].has("kill"), id)
		for dep: String in ev["depends_on"]:
			assert_true(_db.canon.events.has(dep), dep)
			assert_true(int(_db.canon.events[dep]["window"]["earliest"]) <= int(ev["window"]["earliest"]), id + " after " + dep)
	assert_eq(_db.canon.events["b8.riverfarm_shows_its_trebuchets_to_the_nobles"]["window"]["earliest"], 143)
	assert_eq(_db.canon.events["b8.laken_springs_the_night_ambush_on_the_goblin_camp"]["window"]["earliest"], 145)
	assert_eq(_db.canon.events["b8.the_goblins_storm_lancrel"]["window"]["earliest"], 148)


func test_days_143_and_144_are_the_trebuchets_and_magnolias_offer() -> void:
	var gs := _at_day(143)
	ToyCanon.sleep_through(gs, _db, 143)
	_has_all(gs, ["riverfarm.shows_trebuchets_to_the_nobles", "magnolia.offers_laken_peace_for_no_weapon_sales",
			"laken.senses_the_goblin_host_north", "bethal.bids_for_trebuchets"])
	assert_false(gs.flags.has("bethal.leaves_riverfarm_early_westward"))
	ToyCanon.sleep_through(gs, _db, 144)
	_has_all(gs, ["bethal.leaves_riverfarm_early_westward", "wiskeria.rides_out_with_hellebore_and_brewers",
			"laken.has_a_map_of_allies_and_boycotting_towns"])
	assert_false(gs.flags.has("laken.goblin_war_begun"))


func test_day_145_is_the_night_raid_and_rags_falls() -> void:
	var gs := _at_day(145)
	ToyCanon.sleep_through(gs, _db, 145)
	_has_all(gs, ["laken.plans_to_teach_engineering_to_all", "laken.goblin_war_begun", "rags.badly_wounded_at_the_camp",
			"rags.unconscious_after_the_raid", "pyrite.takes_command_while_rags_is_down", "nobles.learn_the_goblin_host_is_near",
			"durene.marches_with_the_army_north", "bethal.saw_a_goblin_child_weep", "kerrig.follows_the_goblins_as_witness"])
	assert_false(gs.flags.has("rags.woke_after_raid"))
	assert_false(gs.flags.has("lancrel.fallen_to_goblins"))


func test_days_146_and_147_are_the_harrying() -> void:
	var gs := _at_day(146)
	ToyCanon.sleep_through(gs, _db, 146)
	_has_all(gs, ["flooded_waters.harried_day_and_night", "pyrite.leads_while_rags_sleeps"])
	assert_false(gs.flags.has("pyrite.takes_five_arrows_and_falls"))
	ToyCanon.sleep_through(gs, _db, 147)
	_has_all(gs, ["pyrite.takes_five_arrows_and_falls", "lancrel.refused_lakens_levy", "flooded_waters.learns_a_great_army_follows"])
	assert_false(gs.flags.has("rags.woke_after_raid"))


func test_day_148_rags_wakes_lancrel_falls_and_the_raids_start() -> void:
	var gs := _at_day(148)
	ToyCanon.sleep_through(gs, _db, 148)
	_has_all(gs, ["rags.woke_after_raid", "rags.decides_to_take_lancrel", "lancrel.fallen_to_goblins", "rags.orders_scorched_earth_raids",
			"goblins.burn_the_villages_near_lancrel", "bethal.done_killing_goblins_for_now", "rags.used_the_fear_gem"])


func test_nobody_named_dies() -> void:
	var gs := _at_day(148)
	ToyCanon.sleep_through(gs, _db, 148)
	for id: String in ["laken_godart", "durene", "rags", "pyrite", "redscar", "wiskeria", "beniar", "kerrig_louis", "bethal",
			"thomast", "nesor", "noears", "poisonbite", "quietstab"]:
		assert_true(gs.world.is_alive(_db.canon, id), id)
