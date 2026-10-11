extends GutTest
## M23.5 (ADR 0036): a key Book 6 NPC dies on day 114 and the game sleeps
## through day 130. Threads that do not need the dead NPC go on; the dead
## NPC's own events cancel; alt events show in the history; drift stays in
## proportion. Key NPCs and events: docs/divergence/picks.md. The game is
## slept once (before_all); each test starts from a copy.

const FIRST_DAY := 114
const LAST_DAY := 130
## Book 6 canon events that did not happen (cancelled or mutated), and total
## drift (all books), at most. Before M23.5: Zel 25 / 15, Magnolia 17 / 10.5,
## Goblin Lord 16 / 9, Erin 14 / 15, Olesm 13 / 13, Oom 9 / 5.5. Zel, Magnolia,
## the Goblin Lord and Erin lose more now: the Battle of Invrisil and the
## Redfang at the inn no longer run without their cause (ADR 0036 "Book 6").
const CEILING := {
	"zel_shivertail": [35, 20.0],
	"magnolia_reinhart": [36, 21.5],
	"goblin_lord": [27, 14.5],
	"erin_solstice": [22, 19.0],
	"olesm": [7, 7.0],
	"oom": [1, 0.5],
}
const ALTS := ["the_redfang_kill_the_eater_goats_at_wirclaws", "the_redfang_go_north_to_seek_rags",
	"pisces_finds_the_hidden_chute_hunting_rats", "zel_stays_in_liscor", "the_silver_swords_arrive_at_the_inn",
	"magnolias_levy_waits_at_invrisil", "the_goblin_lord_goes_round_invrisil",
	"zel_leads_the_levy_against_the_goblin_raiders", "the_inn_mourns_zel"]
## The Battle of Invrisil up to the bone dome.
const BATTLE := ["zel_and_magnolia_plan_the_battle_of_invrisil", "the_battle_of_invrisil_opens",
	"the_goblin_lord_sends_the_undead_and_deathbolt", "reynold_rescues_the_cavalry_in_the_pink_carriage",
	"war_golems_charge_the_goblin_lord", "goblins_hit_magnolias_post", "zel_takes_the_carriage_into_the_goblin_army",
	"zel_cripples_the_goblin_lords_spider_and_wounds_him", "a_dome_of_bone_closes_over_zel"]
## The trap in the dome and Zel's death.
const ZELS_DEATH := ["the_chosen_teleport_into_the_dome", "zel_breaks_the_chosen_and_azkerash_comes",
	"zel_names_the_goblin_lord_reiss_and_dies", "reiss_orders_zels_body_untouched_and_withdraws",
	"magnolia_offers_a_bounty_on_the_necromancer", "klbkch_speaks_to_the_grand_queen_through_the_mirror"]
## The Redfang survivors at the Wandering Inn.
const REDFANG_INN := ["erin_bows_to_the_redfang_and_feeds_them", "halfseekers_brawl_with_the_redfang",
	"zevara_backs_down_on_zels_order", "redfang_sleep_in_the_inn_basement", "the_goblin_party_at_the_inn"]
## The rat contract and the hidden chute in the crypt.
const CRYPT := ["olesm_approves_the_rat_contract", "pisces_tells_the_inn_calruz_may_be_alive"]
## Laken's Riverfarm thread.
const RIVERFARM := ["riverfarm_beats_a_goblin_ambush_on_a_caravan", "laken_rides_the_mossbear_and_builds_a_trebuchet",
	"laken_and_wiskeria_plan_a_mutual_defence", "laken_relieves_rie_estate"]

var _db: DataDb
var _base_json := ""


func before_all() -> void:
	_db = DataDb.load_dir()
	var gs := GameState.new_game(1, _db)
	ToyCanon.sleep_through(gs, _db, FIRST_DAY - 1)
	_base_json = gs.to_json()


## Kills `npcs` on day 114, sleeps through day 130.
func _run(npcs: Array) -> GameState:
	var gs := GameState.from_json(_base_json)
	for npc: String in npcs:
		assert_eq(Commands.kill_npc(gs, _db, npc), "")
	while gs.world.last_day < LAST_DAY:
		Commands.sleep(gs, _db, Rest.ANYWHERE)
	return gs


## Book 6 canon events (not alt events) that did not happen.
func _lost(gs: GameState) -> Array[String]:
	var out: Array[String] = []
	for id: String in _db.canon.events:
		if id.begins_with("b6.") and not _db.canon.alt_only.has(id) and not Director.happened(gs.world.status(id)):
			out.append(id)
	return out


func _check_ceiling(gs: GameState, npc: String) -> void:
	var lost := _lost(gs)
	assert_lte(lost.size(), int(CEILING[npc][0]), "%s: Book 6 events lost" % npc)
	assert_gt(gs.world.drift, 0.0)
	assert_lte(gs.world.drift, float(CEILING[npc][1]), "%s: drift" % npc)
	for id: String in _db.canon.events:
		if id.begins_with("b6.") and int(_db.canon.events[id]["window"]["latest"]) <= LAST_DAY \
				and not _db.canon.alt_only.has(id):
			assert_ne(gs.world.status(id), WorldState.PENDING, "%s is resolved" % id)


func _happened(gs: GameState, ids: Array) -> void:
	for id: String in ids:
		assert_true(Director.happened(gs.world.status("b6." + id)), id)


func _not_happened(gs: GameState, ids: Array) -> void:
	for id: String in ids:
		assert_false(Director.happened(gs.world.status("b6." + id)), id)


func _entry(gs: GameState, id: String) -> Dictionary:
	for h: Dictionary in gs.world.history:
		if h["event"] == id and h["outcome"] != Director.DELAYED:
			return h
	return {}


## The canon event mutated into `alt` on `day`, and the alt ran.
func _mutated(gs: GameState, id: String, alt: String, day: int) -> void:
	var e := _entry(gs, "b6." + id)
	assert_eq(e.get("outcome", ""), Director.MUTATED, id)
	assert_eq(e.get("via", ""), "b6." + alt, id)
	assert_eq(int(e.get("day", 0)), day, "%s mutates on its own day" % id)
	assert_eq(gs.world.status("b6." + alt), Director.DONE, alt)


func test_every_day_with_on_map_canon_has_a_hook() -> void:
	var on_map := {}
	for area: String in _db.maps.areas:
		on_map[_db.maps.areas[area]["location"]] = true
	var days := {}
	var hooked := {}
	for id: String in _db.canon.events:
		var ev: Dictionary = _db.canon.events[id]
		if not id.begins_with("b6.") or _db.canon.alt_only.has(id) or not on_map.has(ev["location"]):
			continue
		var day := int(ev["window"]["earliest"])
		days[day] = true
		for h: Dictionary in ev.get("hooks", []):
			for d in range(int(h["days"][0]), int(h["days"][1]) + 1):
				hooked[d] = true
	assert_eq(days.size(), 15)
	for day: int in days:
		assert_true(hooked.has(day), "day %d has a hook" % day)


func test_helping_with_the_trebuchet_changes_the_day() -> void:
	var gs := GameState.from_json(_base_json)
	ToyCanon.sleep_through(gs, _db, 117)
	assert_eq(gs.clock.day(), 118)
	gs.player.place("riverfarm", Vector2i(16, 18))
	Commands.settle(gs, _db)
	var r := Commands.interact(gs, _db, "trebuchet_frame", "chop_wood")
	assert_eq(r["error"], "")
	ToyCanon.sleep_through(gs, _db, 118)
	var ev := _entry(gs, "b6.laken_rides_the_mossbear_and_builds_a_trebuchet")
	assert_eq(ev["outcome"], Director.CHANGED)
	assert_eq(ev["hook"], "player_helped_build_the_trebuchet")
	assert_true(gs.flags.has("riverfarm.earther_helped_build_the_trebuchet"))
	assert_true(gs.flags.has("riverfarm.builds_trebuchets"), "the canon effects still happen")


func test_no_kill_never_runs_an_alt_event() -> void:
	var gs := _run([])
	assert_eq(_lost(gs), [] as Array[String])
	assert_eq(gs.world.drift, 0.0)
	for id: String in ALTS:
		assert_true(_db.canon.alt_only.has("b6." + id), id)
		assert_eq(gs.world.status("b6." + id), WorldState.PENDING, id)


func test_zel_dies_and_the_goblin_lord_goes_round_invrisil() -> void:
	var gs := _run(["zel_shivertail"])
	_check_ceiling(gs, "zel_shivertail")
	_mutated(gs, "zel_speaks_to_magnolias_army", "magnolias_levy_waits_at_invrisil", 129)
	_mutated(gs, "azkerash_orders_the_goblin_lord_to_attack_invrisil", "the_goblin_lord_goes_round_invrisil", 129)
	assert_true(gs.world.is_alive(_db.canon, "goblin_lord"), "no battle, no wound")
	_happened(gs, REDFANG_INN)
	_happened(gs, CRYPT)
	_happened(gs, RIVERFARM)
	_happened(gs, ["magnolia_hears_of_esthelm_and_laken", "magnolia_confronts_rie", "reynold_charges_the_goblin_vanguard",
		"the_silver_swords_arrive_into_a_cake_fight", "klbkch_reads_the_war_history_to_the_hive",
		"goblins_read_the_war_history_with_osthia"])
	_not_happened(gs, BATTLE)
	_not_happened(gs, ZELS_DEATH)
	_not_happened(gs, ["zel_meets_magnolia", "the_world_reacts_to_zels_speech", "liscor_council_hears_zels_speech"])


func test_magnolia_dies_and_zel_stays_in_liscor() -> void:
	var gs := _run(["magnolia_reinhart"])
	_check_ceiling(gs, "magnolia_reinhart")
	_mutated(gs, "zel_leaves_liscor_through_the_door", "zel_stays_in_liscor", 127)
	_mutated(gs, "azkerash_orders_the_goblin_lord_to_attack_invrisil", "the_goblin_lord_goes_round_invrisil", 129)
	assert_true(gs.world.is_alive(_db.canon, "zel_shivertail"), "no battle, no trap")
	_happened(gs, REDFANG_INN)
	_happened(gs, CRYPT)
	_happened(gs, RIVERFARM)
	_happened(gs, ["ilvriss_and_zel_agree_to_spread_the_word", "the_esthelm_report_reaches_liscor",
		"goblin_lord_breaks_a_human_army_at_a_river_city"])
	_not_happened(gs, BATTLE)
	_not_happened(gs, ZELS_DEATH)
	_not_happened(gs, ["zel_meets_magnolia", "zel_speaks_to_magnolias_army", "the_world_reacts_to_zels_speech"])


func test_the_goblin_lord_dies_and_zel_hunts_the_raiders() -> void:
	var gs := _run(["goblin_lord"])
	_check_ceiling(gs, "goblin_lord")
	_mutated(gs, "zel_and_magnolia_plan_the_battle_of_invrisil", "zel_leads_the_levy_against_the_goblin_raiders", 130)
	assert_true(gs.world.is_alive(_db.canon, "zel_shivertail"), "no Goblin Lord, no trap")
	_happened(gs, ["goblin_lord_army_marches_past_liscor", "zel_meets_magnolia", "magnolia_pitches_a_world_coalition",
		"zel_speaks_to_magnolias_army", "the_world_reacts_to_zels_speech", "liscor_council_hears_zels_speech"])
	_happened(gs, REDFANG_INN)
	_happened(gs, RIVERFARM)
	_not_happened(gs, BATTLE.filter(func(id: String) -> bool: return id != "zel_and_magnolia_plan_the_battle_of_invrisil"))
	_not_happened(gs, ZELS_DEATH)
	_not_happened(gs, ["garen_will_not_kneel_to_the_goblin_lord", "osthia_walks_the_goblin_camp",
		"azkerash_orders_the_goblin_lord_to_attack_invrisil"])


func test_erin_dies_and_the_redfang_go_north() -> void:
	var gs := _run(["erin_solstice"])
	_check_ceiling(gs, "erin_solstice")
	_mutated(gs, "eater_goats_attack_wirclaws_village", "the_redfang_kill_the_eater_goats_at_wirclaws", 115)
	_mutated(gs, "erin_bows_to_the_redfang_and_feeds_them", "the_redfang_go_north_to_seek_rags", 115)
	assert_true(gs.world.is_alive(_db.canon, "bugear"), "an alt event kills no one")
	_mutated(gs, "the_silver_swords_arrive_into_a_cake_fight", "the_silver_swords_arrive_at_the_inn", 129)
	_mutated(gs, "liscor_mourns_zel", "the_inn_mourns_zel", 130)
	_happened(gs, ["ylawes_and_yvlon_argue_and_the_swords_stay", "falene_meets_ceria_and_pisces",
		"klbkch_reads_the_war_history_to_the_hive", "klbkch_and_erin_finish_the_war_history"])
	_happened(gs, CRYPT)
	_happened(gs, BATTLE)
	_happened(gs, ZELS_DEATH)
	_not_happened(gs, REDFANG_INN)
	_not_happened(gs, ["the_morning_after_the_goblin_party", "dawil_names_erins_coin_mithril", "erin_reaches_level_33"])


func test_olesm_dies_and_pisces_finds_the_chute_alone() -> void:
	var gs := _run(["olesm"])
	_check_ceiling(gs, "olesm")
	var contract := _entry(gs, "b6.olesm_approves_the_rat_contract")
	assert_eq(contract["outcome"], Director.SUBSTITUTED)
	assert_eq(contract["roles"]["tactician"], "zevara")
	_mutated(gs, "olesm_and_pisces_find_the_hidden_chute", "pisces_finds_the_hidden_chute_hunting_rats", 126)
	_happened(gs, CRYPT)
	_happened(gs, ["the_esthelm_report_reaches_liscor", "zel_leaves_liscor_through_the_door",
		"liscor_council_hears_zels_speech"])
	_happened(gs, BATTLE)
	_happened(gs, ZELS_DEATH)
	_not_happened(gs, ["niers_sends_olesm_a_letter_and_a_ring", "olesm_reaches_level_28_and_answers_ylawes"])


func test_two_chosen_die_and_the_trap_still_closes() -> void:
	var gs := _run(["oom", "venitra"])
	_check_ceiling(gs, "oom")
	_happened(gs, BATTLE)
	_happened(gs, ZELS_DEATH)
	_not_happened(gs, ["oom_is_destroyed_inside_the_dome"])
	assert_false(gs.world.is_alive(_db.canon, "zel_shivertail"))
