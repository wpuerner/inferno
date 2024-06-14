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
