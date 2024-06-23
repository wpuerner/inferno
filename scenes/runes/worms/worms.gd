extends Rune

@onready var projectile_attribute: Attribute = preload("res://scenes/attributes/projectile/projectile_attribute.tres")

func activate():
	projectile_attribute.set_value(preload("res://scenes/mobs/worm/worm.tscn"))
