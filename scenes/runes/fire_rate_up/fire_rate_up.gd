extends Rune

@export var fire_rate_multipler_attribute: Attribute

func activate():
	fire_rate_multipler_attribute.set_value(fire_rate_multipler_attribute.get_value() * 1.50)
