class_name Attribute extends Resource

signal was_changed(new_value)

var _value
	
func set_value(new_value):
	_value = new_value
	was_changed.emit(_value)

func get_value():
	return _value
	
func get_default_value():
	push_error("Must implement get_default_value for child attributes")

func reset():
	set_value(get_default_value())
