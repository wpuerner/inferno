extends Node

signal level_loaded
func load_level():
	level_loaded.emit()
	
signal pre_level_started
func start_pre_level():
	pre_level_started.emit()
	
signal gameplay_started
func start_gameplay():
	gameplay_started.emit()

signal level_cleared
func clear_level():
	level_cleared.emit()
	
signal player_killed
func kill_player():
	player_killed.emit()
	
signal game_restarted
func restart_game():
	game_restarted.emit()

signal player_health_updated(amount: int)
func update_player_health(amount: int):
	player_health_updated.emit(amount)
	
signal player_picked_up_room_rune(rune: Rune)
func pick_up_room_rune(rune: Rune):
	player_picked_up_room_rune.emit(rune)
	
signal player_requested_next_level()
func request_next_level():
	player_requested_next_level.emit()
	
signal player_activated_hand
func activate_hand():
	player_activated_hand.emit()
