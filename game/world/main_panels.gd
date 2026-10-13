## The panels of the game screen (M26.0, split from main.gd): which panel has
## the keyboard, the debug console, the use menu and the bag, the touch pad and
## the UI scale (M20.1, M20.3), the message history, the night pages, and the
## autosave each time the System dialog closes (each morning).
## Presentation only (CLAUDE.md rule 1).
class_name MainPanels
extends RefCounted

## The MainScreen (untyped: a typed back link makes a script cycle that leaks at exit).
var _m


func _init(screen: Node) -> void:
	_m = screen


## True while a menu, the sheet, the journal, the bag, the System dialog or
## the console has the keyboard.
func is_busy() -> bool:
	return _m.console_layer.visible or panel_open() or _m.dialog.visible or _m.travel.visible \
			or _m.view.is_replaying()


## True while a menu or page panel is open (not the dialog or the console).
func panel_open() -> bool:
	return _m.menu.visible or _m.sheet.visible or _m.journal.visible or _m.bag.visible \
			or _m.pause.visible or _m.message_log.visible or _m.help.visible


## The UI scale factor changed (M20.3): the map and the touch pad keep their
## size on the screen (user, 2026-10-05).
func apply_ui_scale() -> void:
	var f: float = _m.get_window().content_scale_factor
	_m.view.camera.zoom = Vector2.ONE * UiScale.camera_zoom(f)
	_m.touch.set_factor(f)


## Shows the touch controls that fit now (M20.1) and makes room for the pad
## in the HUD.
func sync_touch() -> void:
	var shown: bool = Session.touch_shown()
	_m.touch.sync(shown, panel_open(), _m.dialog.visible or _m.console_layer.visible,
			_m.aim.armed != "" or _m.aim.walking(), Encounter.is_player_turn(Session.gs))
	_m.hud.make_room_left(_m.touch.pad_width() if shown else 0.0)


func toggle_console() -> void:
	var layer: CanvasLayer = _m.console_layer
	layer.visible = not layer.visible
	if layer.visible:
		_m.menu.close()
		_m.sheet.close()
		_m.journal.close()
		_m.bag.close()
		_m.pause.close()
		_m.console_input.grab_focus()
	else:
		_m.console_input.release_focus()


func open_use_menu() -> void:
	if not _m.menu.open(Interact.options(Session.gs, Session.db), Session.db):
		_m.hud.add_lines(["There is nothing to use here."])


## The bag (F): eat or drink something you carry.
func open_bag() -> void:
	if not _m.menu.open_bag(Session.gs, Session.db):
		_m.hud.add_lines(["You have nothing to eat or drink. (Coins: %s)" % Economy.format(Session.db,
				Session.gs.economy.coins)])


## A pick on the bag screen: runs it like a use-menu pick, then shows the
## bag again (not when the player went down or the day ended).
func use_from_bag(action_id: String) -> void:
	_m.use("bag", action_id)
	if not Combat.is_down(Session.gs) and not _m.dialog.visible:
		_m.bag.open(Session.gs, Session.db)


## The message history, newest first (the L page).
func history_lines() -> Array:
	var lines: Array = _m.hud.history()
	lines.reverse()
	return lines


## "Day 3, 06:00." with the day counted from the player's arrival (M15.1).
func day_line() -> String:
	return "Day %d, %s." % [Clock.player_day(Session.gs.clock.day(), Session.db.rules["clock"]),
			Session.gs.clock.time_string()]


## The night (a sleep, a collapse or a knock-out) in the System dialog.
func show_night(night: Dictionary) -> void:
	var what := "You sleep."
	if night["knocked_out"]:
		what = "Everything goes dark."
	elif night["collapsed"]:
		what = "You collapse."
	_m.hud.add_lines([what])
	Session.changed()
	_m.dialog.open(SystemMessages.pages(night, Session.gs, Session.db), Session.gs, Session.db)


## The System dialog closed: the day line, then the autosave.
func on_dialog_closed() -> void:
	_m.hud.add_lines([day_line()])
	if Session.autosave() != OK:
		_m.hud.add_lines(["Autosave failed."])
	Session.changed()
