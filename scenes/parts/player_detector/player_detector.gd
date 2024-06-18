extends Area2D

signal player_detected(player: Node2D)

func _on_body_entered(body: Node2D):
	player_detected.emit(body)
