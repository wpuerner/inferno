extends Area2D

@export var damage_amount: int = 10

func _on_body_entered(body):
	if "health_attribute" in body:
		body.health_attribute.apply_damage(damage_amount)
