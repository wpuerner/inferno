extends Node

signal health_was_depleated

@export var health: int

func apply_damage(amount: int):
	health -= amount
	if health <= 0:
		health_was_depleated.emit()
