class_name ArrayAttribute extends Attribute

func add(value):
	get_value().append(value)

func reset():
	if get_value() == null:
		set_value([])
	else: get_value().clear()
