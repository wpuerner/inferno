extends Node

signal player_ready(player: Node2D)
func ready_player(player: Node2D):
	player_ready.emit(player)

signal level_reset()
func reset_level():
	level_reset.emit()
