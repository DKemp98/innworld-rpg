extends GutTest
## M24.3: every class has a rare Skill for its level 10 capstone and a second one for level 20.

var _db: DataDb


func before_all() -> void:
	_db = DataDb.load_dir()
	assert_eq(_db.errors, [] as Array[String])


func test_every_class_has_two_rare_skills_for_the_first_two_capstones() -> void:
	for cid: String in _db.classes:
		var gs := GameState.new_game(1, _db, "celum")
		var first := SkillSystem.grant_random(gs, _db, cid, 10, true)
		assert_ne(first, "", "%s: a Skill at 10" % cid)
		assert_eq(_db.skills[first]["rarity"], "rare", "%s: rare at 10" % cid)
		var second := SkillSystem.grant_random(gs, _db, cid, 20, true)
		assert_ne(second, "", "%s: a Skill at 20" % cid)
		assert_eq(_db.skills[second]["rarity"], "rare", "%s: rare at 20" % cid)
		assert_ne(first, second, "%s: two different Skills" % cid)


func test_a_capstone_skill_is_not_found_before_its_level() -> void:
	var gs := GameState.new_game(1, _db, "celum")
	for cid: String in ["archer", "knight", "carpenter", "rider"]:
		assert_eq(SkillSystem.candidates(gs, _db, cid, 9, true).size(), 0, "%s: no rare Skill at 9" % cid)


func test_new_capstone_combat_actions_work_in_a_fight() -> void:
	for id: String in ["crushing_blow", "lance_strike", "backstab", "trampling_charge"]:
		var a := CombatSkills.action_of(_db, id)
		assert_false(a.is_empty(), "%s is a combat Skill" % id)
		assert_gt(int(a["ap_q"]), 0)
		assert_gt(int(a["cooldown"]), 0)
