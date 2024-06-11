class_name Attribute extends Resource

var value
	
func set_value(new_value):
	value = new_value

func get_value():
	return value
	
func get_default_value():
	push_error("Must implement get_default_value for child attributes")

func reset():
	value = get_default_value()
