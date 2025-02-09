extends Attribute

@export var max_health: int = 8

func set_value(new_value: int):
	if new_value <= max_health:
		super(new_value)

func get_default_value():
	return get_value()
