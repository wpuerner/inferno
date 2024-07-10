extends Node2D

func _physics_process(delta: float):
	global_position += Vector2(400, 0).rotated(global_rotation) * delta

func _on_hurtbox_hurtbox_collided(_body):
	queue_free()

func _on_body_entered(body):
	var explosion = preload("res://scenes/effects/explosion/explosion.tscn").instantiate()
	explosion.global_position = global_position
	call_deferred("add_sibling", explosion)
	queue_free()
