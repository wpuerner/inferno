class_name ArrayAttribute extends Attribute

@export var value: Array

func add(value):
	var array = get_value()
	array.append(value)
	set_value(array)

func get_default_value():
	return value
