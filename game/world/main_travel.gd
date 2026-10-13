## The long-road prompt on the game screen (M26.0, split from main.gd). A step
## onto a long road (TravelPrompt.LONG_MINUTES: 10 h between Celum, the camp and
## Liscor) asks first and plays a short walk (user, 2026-10-08); the step is
## made after the walk. Off when MainScreen.confirm_travel is false (headless).
## Presentation only (CLAUDE.md rule 1).
class_name MainTravel
extends RefCounted

var prompt: TravelPrompt

## The MainScreen (untyped: a typed back link makes a script cycle that leaks at exit).
var _m
## The direction of the step that waits for the walk ("" = none).
var _dir := ""


func _init(screen: Node, layer: Node) -> void:
	_m = screen
	prompt = TravelPrompt.new()
	layer.add_child(prompt)
	prompt.cancelled.connect(_on_cancelled)
	prompt.arrived.connect(_on_arrived)


## A step in `dir` onto a long road opens the prompt and returns true.
func ask(dir: String) -> bool:
	if not _m.confirm_travel or not PlayerState.DIRS.has(dir):
		return false
	var gs := Session.gs
	var db := Session.db
	var e := db.maps.exit_at(gs.player.area, gs.player.pos() + (PlayerState.DIRS[dir] as Vector2i))
	if e.is_empty() or not TravelPrompt.is_long(int(e["minutes"])):
		return false
	_dir = dir
	_m.aim.cancel_walk()
	prompt.ask(String(db.maps.areas[gs.player.area]["name"]), String(db.maps.areas[e["to"]]["name"]),
			int(e["minutes"]))
	return true


func _on_cancelled() -> void:
	_dir = ""


## The walk is over and the screen is covered: make the step.
func _on_arrived() -> void:
	var dir := _dir
	_dir = ""
	var was: bool = _m.confirm_travel
	_m.confirm_travel = false
	_m.step(dir)
	_m.confirm_travel = was
