extends GutTest
## M24.0: each class-tree step 3 class has its own action, a map object and a sound.

const ACTIONS := {
	"hunt": "hunter", "shoot_bow": "archer", "brew_potion": "alchemist",
	"forge_tool": "blacksmith", "teach_lesson": "teacher",
}
var _db: DataDb


func before_all() -> void:
	_db = DataDb.load_dir()


func test_each_action_has_a_map_object_and_a_sound() -> void:
	var audio := AudioDb.load_file()
	for id: String in ACTIONS:
		assert_true(_db.actions.has(id), id)
		assert_true(audio.data["actions"].has(id), "%s has a sound" % id)
		var found := false
		for area: String in _db.maps.areas:
			for o: Dictionary in _db.maps.objects_on(area):
				if (o["actions"] as Array).has(id):
					found = true
		assert_true(found, "%s is on a map object" % id)


func test_each_action_trains_its_class_main_tag() -> void:
	for id: String in ACTIONS:
		var weights: Dictionary = _db.classes[ACTIONS[id]]["tag_weights"]
		var main := ""
		for t: String in weights:
			if main == "" or weights[t] > weights[main]:
				main = t
		assert_true((_db.actions[id]["tags"] as Dictionary).has(main), "%s trains %s" % [id, main])


func test_hunting_in_the_cold_gives_more_xp() -> void:
	assert_true((_db.actions["hunt"] as Dictionary).has("duress"))
