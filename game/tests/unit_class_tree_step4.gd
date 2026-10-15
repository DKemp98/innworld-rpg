extends GutTest
## Class tree step 4: 4 base classes, 7 advancements, 4 consolidations (15 classes).

const BASE := ["tailor", "glassblower", "tinkerer", "bard"]
const ADVANCE := {
	"pyromancer": "mage", "necromancer": "mage", "illusionist": "mage",
	"armorer": "blacksmith", "weaponsmith": "blacksmith", "trader": "merchant", "diplomat": "strategist",
}
const MERGE := {
	"battlemage": ["warrior", "mage"], "paladin": ["knight", "priest"],
	"spymaster": ["rogue", "strategist"], "apothecary": ["herbalist", "alchemist"],
}
var _db: DataDb


func before_all() -> void:
	_db = DataDb.load_dir()


func _all_new() -> Array:
	var ids: Array = BASE.duplicate()
	ids.append_array(ADVANCE.keys())
	ids.append_array(MERGE.keys())
	return ids


func test_each_new_class_uses_known_tags_and_has_a_skill() -> void:
	for id: String in _all_new():
		assert_true(_db.classes.has(id), id)
		for tag: String in _db.classes[id]["tag_weights"]:
			assert_true(_db.tags.has(tag), "%s uses tag %s" % [id, tag])
		var has_skill := false
		for sk: Dictionary in _db.skills.values():
			for pool: Dictionary in sk["pools"]:
				if pool["class"] == id:
					has_skill = true
		assert_true(has_skill, "%s has a Skill" % id)


func test_advancements_need_their_base_class() -> void:
	for id: String in ADVANCE:
		assert_eq(_db.classes[id]["prereqs"]["classes"], [ADVANCE[id]], id)


func test_consolidations_list_their_sources() -> void:
	for id: String in MERGE:
		var c: Variant = _db.classes[id]["consolidation"]
		assert_not_null(c, id)
		assert_eq(c["from"], MERGE[id], id)
		for src: String in c["from"]:
			assert_true(_db.classes.has(src), "%s source %s exists" % [id, src])


func test_base_classes_are_offered_from_practice() -> void:
	var gs := GameState.new()
	for id: String in BASE:
		gs.progression.pools[id] = 1000.0
	var offers: Array = ClassSystem.make_offers(gs, _db, 4)
	for id: String in BASE:
		assert_true(offers.has(id), id)


func test_pyromancer_offer_needs_mage() -> void:
	var gs := GameState.new()
	gs.progression.pools["pyromancer"] = 1000.0
	assert_false(ClassSystem.make_offers(gs, _db, 2).has("pyromancer"))
	ToyData.give_class(gs, "mage", 5)
	assert_true(ClassSystem.make_offers(gs, _db, 2).has("pyromancer"))
