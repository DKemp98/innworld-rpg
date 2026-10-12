extends GutTest
## M25.3: an NPC's sheet, read with [Appraisal].

var _db: DataDb


func before_all() -> void:
	_db = DataDb.load_dir()


func _game() -> GameState:
	return GameState.new_game(1, _db, "celum")


func test_unknown_levels_show_a_question_mark() -> void:
	var gs := _game()
	for npc: String in ["merec", "raisha", "reynold", "ressa", "magnolia_reinhart"]:
		var text := "\n".join(NpcSheet.lines(gs, _db, npc))
		assert_true(text.contains(String(_db.canon.npcs[npc]["name"])), npc)
		assert_true(text.contains("level ?"), "%s: %s" % [npc, text])
		assert_false(text.contains("level 12"), npc)


func test_a_known_level_is_shown_and_no_total() -> void:
	var gs := _game()
	var text := "\n".join(NpcSheet.lines(gs, _db, "relc"))
	assert_true(text.contains("[Spearmaster] level 33"), text)
	assert_false(text.to_lower().contains("total"))


func test_a_golem_has_no_classes() -> void:
	var text := "\n".join(NpcSheet.lines(_game(), _db, "reinhart_golem_west"))
	assert_true(text.contains("None."))


func test_only_appraisal_reads_sheets() -> void:
	var gs := _game()
	assert_false(NpcSheet.can_read(gs, _db))
	gs.progression.skills.append({"id": "appraisal", "class": "merchant", "level": 4, "day": 1})
	assert_true(NpcSheet.can_read(gs, _db))


func test_the_menu_offers_appraise_only_with_the_skill() -> void:
	var gs := _game()
	gs.player.place("invrisil_merchants_guild", Vector2i(10, 4))
	gs.npcs.npcs["merec"] = {"area": "invrisil_merchants_guild", "x": 10, "y": 5, "facing": "down"}
	var has := func() -> bool:
		for o: Dictionary in Interact.options(gs, _db):
			if o["id"] == "merec":
				return o.get("appraise", false)
		return false
	assert_false(has.call())
	gs.progression.skills.append({"id": "appraisal", "class": "merchant", "level": 4, "day": 1})
	assert_true(has.call())


func test_an_unknown_npc_has_no_lines() -> void:
	assert_eq(NpcSheet.lines(_game(), _db, "nobody").size(), 0)
