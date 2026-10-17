extends GutTest
## M28.9 (ADR 0043): kill sims for Book 8. The named dead (Fess, Rebat, Cassa, Vakk) die by their own canon
## events. A key NPC (Calruz, Nokha, Erin, Ceria) dies at the start of day 162 and the game sleeps through
## day 164: nothing crashes, every Book 8 event to day 163 resolves, and the threads that do not need the dead
## NPC go on (the captives still come home). The game is slept once (before_all); each test starts from a copy.

const KILL_DAY := 162
const LAST_DAY := 164
const NAMED_DEAD := ["fess", "rebat", "cassa", "vakk"]
const CAPTIVE := ["mrsha.taken_by_the_raskghar", "ceria.taken_by_the_raskghar", "calruz.holds_ceria",
		"mrsha.caged_in_the_raskghar_camp"]
const BATTLE := "b8.three_doors_open_on_the_raskghar_camp"
const PRISON := "b8.calruz_is_taken_to_the_watch_prison"

var _db: DataDb
var _base_json := ""


func before_all() -> void:
	_db = DataDb.load_dir()
	assert_eq(_db.errors, [] as Array[String])
	var gs := GameState.new_game(1, _db)
	ToyCanon.sleep_through(gs, _db, KILL_DAY - 1)
	_base_json = gs.to_json()


## Kills `npcs` at the start of day 162, sleeps through day 164.
func _run(npcs: Array) -> GameState:
	var gs := GameState.from_json(_base_json)
	assert_eq(gs.clock.day(), KILL_DAY)
	for npc: String in npcs:
		assert_eq(Commands.kill_npc(gs, _db, npc), "", npc + " can be killed")
		assert_false(gs.world.is_alive(_db.canon, npc), npc + " is dead")
	while gs.world.last_day < LAST_DAY:
		Commands.sleep(gs, _db, Rest.ANYWHERE)
	return gs


## Book 8 canon events (not alt events) up to day 163 that did not happen.
func _lost(gs: GameState) -> Array[String]:
	var out: Array[String] = []
	for id: String in _db.canon.events:
		if id.begins_with("b8.") and not _db.canon.alt_only.has(id) and not Director.happened(gs.world.status(id)):
			out.append(id)
	return out


func _all_resolved(gs: GameState) -> void:
	for id: String in _db.canon.events:
		if id.begins_with("b8.") and not _db.canon.alt_only.has(id) \
				and int(_db.canon.events[id]["window"]["latest"]) <= LAST_DAY - 1:
			assert_ne(gs.world.status(id), WorldState.PENDING, "%s is resolved" % id)


func _captives_home(gs: GameState) -> void:
	for f: String in CAPTIVE:
		assert_false(gs.flags.has(f), f + " is cleared")


func test_each_named_dead_dies_by_one_book8_event() -> void:
	var by := {}
	for id: String in _db.canon.events:
		if not id.begins_with("b8.") or _db.canon.alt_only.has(id):
			continue
		for n: String in _db.canon.events[id]["effects"].get("kill", []):
			by[n] = int(by.get(n, 0)) + 1
	for n: String in NAMED_DEAD:
		assert_true(_db.canon.npcs.has(n), n + " has a record")
		assert_eq(int(by.get(n, 0)), 1, n)
	for n: String in ["nokha", "calruz", "fleetfur", "beetlestare"]:
		assert_false(by.has(n), n + " is not killed by canon")


func test_no_kill_ends_book8_in_canon() -> void:
	var gs := _run([])
	assert_eq(_lost(gs), [] as Array[String])
	assert_eq(gs.world.drift, 0.0)
	_all_resolved(gs)
	for n: String in NAMED_DEAD:
		assert_false(gs.world.is_alive(_db.canon, n), n)
	for n: String in ["calruz", "nokha", "mrsha", "ceria_springwalker", "erin_solstice"]:
		assert_true(gs.world.is_alive(_db.canon, n), n)
	_captives_home(gs)
	assert_true(gs.flags.has("calruz.in_watch_prison"))
	assert_true(gs.flags.has("izril.rains"))
	assert_true(gs.flags.has("izril.flood"))


func test_calruz_dies_and_the_captives_still_come_home() -> void:
	var gs := _run(["calruz"])
	_all_resolved(gs)
	assert_gt(gs.world.drift, 0.0)
	assert_false(Director.happened(gs.world.status(PRISON)), "no prisoner to take")
	assert_false(gs.flags.has("calruz.in_watch_prison"))
	assert_false(gs.world.is_alive(_db.canon, "calruz"), "he stays dead")
	assert_true(Director.happened(gs.world.status(BATTLE)), "the battle still comes")
	_captives_home(gs)
	assert_true(gs.flags.has("ceria.freed_from_the_raskghar"))
	assert_true(gs.flags.has("mrsha.rescued_from_the_raskghar"))


func test_nokha_dies_and_the_raid_and_battle_still_run() -> void:
	var gs := _run(["nokha"])
	_all_resolved(gs)
	assert_gt(gs.world.drift, 0.0)
	assert_true(gs.flags.has("raskghar.camp_raid_failed"), "the raid fails without her")
	assert_true(Director.happened(gs.world.status(BATTLE)))
	assert_true(gs.flags.has("calruz.in_watch_prison"))
	_captives_home(gs)


func test_erin_dies_and_liscor_still_breaks_the_raskghar() -> void:
	var gs := _run(["erin_solstice"])
	_all_resolved(gs)
	assert_gt(gs.world.drift, 0.0)
	assert_false(Director.happened(gs.world.status(BATTLE)), "no door without Erin")
	assert_false(gs.flags.has("erin.has_natural_allies_goblins"))
	assert_true(gs.flags.has("calruz.in_watch_prison"))
	_captives_home(gs)


func test_ceria_dies_and_mrsha_is_still_saved() -> void:
	var gs := _run(["ceria_springwalker"])
	_all_resolved(gs)
	assert_gt(gs.world.drift, 0.0)
	assert_true(gs.flags.has("mrsha.rescued_from_the_raskghar"))
	assert_false(gs.flags.has("mrsha.taken_by_the_raskghar"))
	assert_true(gs.flags.has("calruz.in_watch_prison"))
