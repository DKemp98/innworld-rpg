extends GutTest
## M24.1: new dishes, the smithy shop and its held weapons.

var _db: DataDb


func before_all() -> void:
	_db = DataDb.load_dir()


func _cook(action: String, station: String, bag: Dictionary) -> GameState:
	var gs := GameState.new_game(1, _db, "celum")
	var at := Interact.object_of(_db, "inn_interior", "stove")
	gs.player.place("inn_interior", Vector2i(int(at["at"][0]), int(at["at"][1]) + 1))
	Commands.settle(gs, _db)
	for g: String in bag:
		gs.economy.add(g, bag[g])
	Commands.interact(gs, _db, station, action)
	return gs


func test_new_dishes_come_from_the_stove() -> void:
	gs_check(_cook("bake_pizza", "stove", {"flour": 1, "vegetables": 1, "meat": 1}), "pizza", 2)
	gs_check(_cook("roast_meat", "stove", {"meat": 1}), "roast_meat", 2)
	gs_check(_cook("cook_vegetable_soup", "stove", {"vegetables": 2}), "vegetable_soup", 3)


func gs_check(gs: GameState, good: String, n: int) -> void:
	assert_eq(gs.economy.count(good), n, good)


func test_every_recipe_action_is_on_a_station() -> void:
	for id: String in _db.economy.recipes:
		var act: String = _db.economy.recipes[id]["action"]
		assert_true(_db.actions.has(act), act)
		assert_true(AudioDb.load_file().data["actions"].has(act), "%s has a sound" % act)


func test_the_smithy_sells_weapons_you_can_hold() -> void:
	var gs := GameState.new_game(1, _db, "celum")
	for good: String in ["wooden_club", "iron_dagger", "hand_axe"]:
		assert_true(_db.economy.shops["liscor_smith"]["sells"].has(good))
		assert_true(_db.combat.items.has(_db.economy.goods[good]["item"]), good)
	gs.economy.add("iron_dagger", 1)
	assert_eq(Commands.hold_good(gs, _db, "iron_dagger"), "")
	assert_eq(gs.player.held, "iron_dagger")
