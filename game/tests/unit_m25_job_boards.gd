extends GutTest
## M25.2: paid job boards in more places.

var _db: DataDb

const BOARDS := [
	["liscor_adventurers_guild", "job_board", "take_guild_job", 6, 12],
	["invrisil_merchants_guild", "contract_board", "tally_ledgers", 4, 8],
	["invrisil_square", "invrisil_notice", "haul_goods", 3, 5],
	["celum_square", "celum_job_board", "haul_goods", 3, 5],
]


func before_all() -> void:
	_db = DataDb.load_dir()


func _at_board(area: String, obj: String) -> GameState:
	var gs := GameState.new_game(1, _db, "celum")
	var at := Interact.object_of(_db, area, obj)
	var p := Vector2i(int(at["at"][0]), int(at["at"][1]) + 1)
	gs.player.place(area, p)
	Commands.settle(gs, _db)
	return gs


func test_each_board_pays_in_its_range() -> void:
	for b: Array in BOARDS:
		var gs := _at_board(b[0], b[1])
		var before := gs.economy.coins
		assert_eq(Commands.interact(gs, _db, b[1], b[2])["error"], "", "%s %s" % [b[0], b[2]])
		assert_between(gs.economy.coins - before, b[3], b[4], b[2])


func test_the_same_seed_pays_the_same() -> void:
	var a := _at_board("liscor_adventurers_guild", "job_board")
	var b := _at_board("liscor_adventurers_guild", "job_board")
	Commands.interact(a, _db, "job_board", "take_guild_job")
	Commands.interact(b, _db, "job_board", "take_guild_job")
	assert_eq(a.economy.coins, b.economy.coins)


func test_every_job_action_has_a_sound() -> void:
	var sounds: Dictionary = AudioDb.load_file().data["actions"]
	for id: String in ["take_guild_job", "tally_ledgers", "haul_goods"]:
		assert_true(sounds.has(id), id)
