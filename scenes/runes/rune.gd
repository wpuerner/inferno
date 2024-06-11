class_name Rune extends Node

@export var display_name: String
@export var texture: Texture

@onready var modifiers: Array[Modifier] = _get_modifiers()

func activate():
	if modifiers.size() == 0:
		push_error("Activate not implemented for a Rune!")
	else:
		for modifier in modifiers:
			modifier.activate()
	
func get_modifier_display_names() -> PackedStringArray:
	return modifiers.map(func(modifier): return modifier.display_name)

func _get_modifiers() -> Array[Modifier]:
	var modifiers: Array[Modifier]
	get_children().map(func(child): modifiers.append(child))
	return modifiers
