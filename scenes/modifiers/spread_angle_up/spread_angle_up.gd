extends Modifier

@export var spread_angle_attribute: Attribute

func activate():
	spread_angle_attribute.set_value(spread_angle_attribute.get_value() + 20)
