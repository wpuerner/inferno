class_name Rune extends Node

@export var display_name: String
@export var texture: Texture
@export var description_strings: PackedStringArray

@onready var modifiers: Array[Modifier] = _get_modifiers()

var is_in_deck: bool = false

func activate():
	if modifiers.size() == 0:
		push_error("Runes must either have modifiers as children or override activate()")
	else:
		for modifier in modifiers:
			modifier.activate()
	
func get_modifier_display_names() -> PackedStringArray:
	var mod_arr: PackedStringArray = modifiers.map(func(modifier): return modifier.display_name)
	return description_strings if mod_arr.is_empty() else mod_arr

func _get_modifiers() -> Array[Modifier]:
	var mods: Array[Modifier] = []
	get_children().map(func(child): mods.append(child))
	return mods
