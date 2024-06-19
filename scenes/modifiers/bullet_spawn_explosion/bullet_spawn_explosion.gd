extends Modifier

@onready var bullet_spawn_attribute: Attribute = load("res://scenes/attributes/bullet_spawn/bullet_spawn_attribute.tres")

func activate():
	bullet_spawn_attribute.set_value("res://scenes/effects/explosion/explosion.tscn")
