class_name Hurtbox extends Area2D

@export var damage_amount: int = 10

func _on_body_entered(body):
	if body.has_method("apply_damage"):
		body.apply_damage(damage_amount)
