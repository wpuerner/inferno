extends Node

signal player_ready(player: Node2D)
func ready_player(player: Node2D):
	player_ready.emit(player)

signal level_loaded
func load_level():
	level_loaded.emit()
	
signal pre_level_started
func start_pre_level():
	pre_level_started.emit()
	
signal gameplay_started
func start_gameplay():
	gameplay_started.emit()

signal exit_opened
func open_exit():
	exit_opened.emit()
