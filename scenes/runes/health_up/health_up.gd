extends Rune

@export var player_health_attribute: Attribute

func activate():
	player_health_attribute.set_value(player_health_attribute.get_value() + 1)
