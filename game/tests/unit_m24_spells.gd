extends GutTest
## M24.2: [Gust], spellbooks for every taught spell, and the Mages' Guild shelf.

var _db: DataDb


func before_all() -> void:
	_db = DataDb.load_dir()
	assert_eq(_db.errors, [] as Array[String])


func test_every_player_spell_has_a_spellbook_that_is_sold() -> void:
	var sold: Array = _db.economy.shops["liscor_mages_guild"]["sells"]
	for id: String in _db.spells.ids():
		var book := String(_db.spells.spells[id].get("learn", {}).get("book", ""))
		assert_ne(book, "", "%s has a book" % id)
		assert_true(sold.has(book), "%s is on the shelf" % book)
		assert_eq(_db.economy.goods[book]["teaches"], id)


func test_the_shelf_is_on_the_mages_guild_map() -> void:
	var found := false
	for o: Dictionary in _db.maps.objects_on("liscor_mages_guild"):
		if String(o.get("shop", "")) == "liscor_mages_guild":
			found = true
	assert_true(found)


func test_a_bought_book_teaches_gust() -> void:
	var gs := GameState.new_game(1, _db, "celum")
	gs.economy.add("spellbook_gust", 1)
	assert_eq(Commands.use_good(gs, _db, "spellbook_gust"), "")
	assert_true(Spells.known(gs, _db).has("gust"))


func test_pisces_casts_gust_after_the_fly_fight() -> void:
	var s: Array = _db.behaviour.combat_of("pisces")["spells"]
	assert_eq(s[0]["id"], "frozen_wind", "the stronger spell is tried first")
	assert_eq(s[1]["id"], "gust")
