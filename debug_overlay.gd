extends Node

@onready var label: Label = get_node_or_null("/root/DebugOverlay/DebugDisplay")
var data = {}

func print(key: String, value):
	data[key] = value
	if !is_instance_valid(label): return
	label.text = ""
	for debug_key in data.keys():
		label.text += debug_key + ": " + str(data[debug_key]) + "\n"

func bind_debug_label(label_to_bind: Label):
	label = label_to_bind
