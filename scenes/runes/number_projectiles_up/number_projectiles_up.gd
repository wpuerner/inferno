extends Rune

@export var number_projectiles_attribute: Attribute

func activate():
	number_projectiles_attribute.set_value(number_projectiles_attribute.get_value() + 1)
