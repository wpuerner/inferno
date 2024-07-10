extends Area2D

signal hurtbox_collided(body: Node2D)

@export var damage_amount: int = 10

func _on_body_entered(body):
	if "health_attribute" in body:
		body.health_attribute.apply_damage(damage_amount)
	elif body.has_node("EntityHealth"):
		body.get_node("EntityHealth").apply_damage(damage_amount)
	hurtbox_collided.emit(body)
