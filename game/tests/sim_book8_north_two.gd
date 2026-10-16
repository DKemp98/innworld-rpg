extends GutTest
## M28.5 on the real Book 8 data (5.30 G, 5.31 G, 5.32 G, days 149 - 150; the Drake talks on day 157): the siege of
## Dwarfhalls Rest, Tyrion's march, the totems, the trebuchets at Lancrel, the forged order, Rags at Riverfarm,
## Tyrion saves Laken, Elia Arcsinger breaks the siege. All off the map: no stage, no hook, no xp_window.

const SEED := 20261016

var _db: DataDb
var _base := ""


func before_all() -> void:
	_db = DataDb.load_dir()
	assert_eq(_db.errors, [] as Array[String])
	var gs := GameState.new_game(SEED, _db)
	ToyCanon.sleep_through(gs, _db, 148)
	_base = gs.to_json()


func _at_day(day: int) -> GameState:
	var gs := GameState.from_json(_base)
	if day > 149:
		ToyCanon.sleep_through(gs, _db, day - 1)
	assert_eq(gs.clock.day(), day)
	return gs


## The 5.30G - 5.32G canon events. Alt events (M23.6) are left out.
func _batch_ids() -> Array[String]:
	var ids: Array[String] = []
	for id: String in _db.canon.events:
		var ref: Dictionary = _db.canon.events[id]["canon_ref"]
		if int(ref["book"]) == 8 and String(ref["chapter"]) in ["5.30G", "5.31G", "5.32G"] and not _db.canon.alt_only.has(id):
			ids.append(id)
	return ids


func _has_all(gs: GameState, flags: Array) -> void:
	for f: String in flags:
		assert_true(gs.flags.has(f), f)


func test_the_batch_is_off_map_and_in_order() -> void:
	var ids := _batch_ids()
	assert_eq(ids.size(), 32)
	for id: String in ids:
		var ev: Dictionary = _db.canon.events[id]
		assert_false(ev.has("stage"), id)
		assert_false(ev.has("hooks"), id)
		assert_false(ev.has("xp_window"), id)
		assert_false(ev["effects"].has("kill"), id)
		var e := int(ev["window"]["earliest"])
		assert_true((e >= 148 and int(ev["window"]["latest"]) <= 150) or e == 157, id)
		for dep: String in ev["depends_on"]:
			assert_true(_db.canon.events.has(dep), dep)
			assert_true(int(_db.canon.events[dep]["window"]["earliest"]) <= e, id + " after " + dep)
	assert_eq(_db.canon.events["b8.the_goblin_lord_lays_siege_to_dwarfhalls_rest"]["window"]["earliest"], 149)
	assert_eq(_db.canon.events["b8.elia_arcsinger_breaks_the_mountain_siege"]["window"]["earliest"], 150)
	assert_eq(_db.canon.events["b8.drake_cities_fret_over_the_antinium_tunnel"]["window"]["earliest"], 157)


func test_day_149_the_siege_starts_and_the_first_stones_fall() -> void:
	var gs := _at_day(149)
	ToyCanon.sleep_through(gs, _db, 149)
	_has_all(gs, ["tyrion.army_marches_south", "goblin_lord.named_reiss", "garen.struck_at_reiss_in_parley",
			"dwarfhalls_rest.besieged_by_the_goblin_lord", "dwarfhalls_rest.outer_tunnels_lost", "osthia.advises_reiss_unwillingly",
			"pyrite.knows_the_totems_are_the_emperors_eyes", "laken.totems_being_cut_down", "riverfarm.trebuchets_bombard_lancrel",
			"flooded_waters.built_a_trebuchet", "flooded_waters.lost_many_redfang_riders"])
	assert_false(gs.flags.has("izril.tyrion_waits_for_the_rain_to_stop"))
	assert_false(gs.flags.has("rags.offers_peace_through_kerrig"))
	assert_false(gs.flags.has("riverfarm.forged_attack_order"))


func test_day_150_the_forged_order_and_the_battle_at_lancrel() -> void:
	var gs := _at_day(150)
	ToyCanon.sleep_through(gs, _db, 150)
	_has_all(gs, ["rags.offers_peace_through_kerrig", "laken.holds_the_attack_on_lancrel", "riverfarm.forged_attack_order",
			"nesor.knocked_out_and_dumped", "laken.did_not_order_the_attack", "flooded_waters.won_the_field_at_lancrel",
			"durene.badly_wounded_by_pyrite", "rags.met_laken_face_to_face", "laken.refused_rags_peace",
			"redscar.lanced_through_the_shoulder", "flooded_waters.driven_back_into_lancrel"])


func test_day_150_elia_breaks_the_siege_and_tyrion_allies_with_laken() -> void:
	var gs := _at_day(150)
	ToyCanon.sleep_through(gs, _db, 150)
	_has_all(gs, ["dwarfhalls_rest.lost_by_tremborag", "dwarfhalls_rest.siege_broken", "goblins.flee_the_kingslayer",
			"tyrion.arrived_at_riverfarm", "laken.allied_with_tyrion", "tyrion.allied_with_laken"])
	assert_false(gs.flags.has("dwarfhalls_rest.besieged_by_the_goblin_lord"))
	assert_true(gs.flags.has("izril.rains"))
	assert_true(gs.flags.has("izril.flood"))


func test_the_drake_talks_wait_for_pisces_leak() -> void:
	var gs := _at_day(150)
	ToyCanon.sleep_through(gs, _db, 156)
	assert_true(gs.flags.has("liscor.antinium_dungeon_entrance_known") or gs.flags.has("horns_of_hammerad.leak_the_antinium_entrance"))
	assert_false(gs.flags.has("drakes.alarmed_by_the_antinium_dungeon_tunnel"))
	ToyCanon.sleep_through(gs, _db, 157)
	assert_true(gs.flags.has("drakes.alarmed_by_the_antinium_dungeon_tunnel"))
	assert_true(gs.flags.has("izril.rains"))
	assert_true(gs.flags.has("izril.flood"))


func test_nobody_named_dies() -> void:
	var gs := _at_day(150)
	ToyCanon.sleep_through(gs, _db, 150)
	for id: String in ["laken_godart", "durene", "beniar", "wiskeria", "gamel", "prost", "rie", "nesor", "kerrig_louis",
			"bevia_veniford", "rags", "pyrite", "redscar", "noears", "tremborag", "garen", "goblin_lord", "snapjaw",
			"eater_of_spears", "ulvama", "osthia_blackwing", "tyrion_veltras", "elia_arcsinger", "welca_caveis"]:
		assert_true(gs.world.is_alive(_db.canon, id), id)
