extends Node2D

func _physics_process(delta: float):
	global_position += Vector2(400, 0).rotated(global_rotation) * delta

func _on_hurtbox_hurtbox_collided(_body):
	queue_free()
