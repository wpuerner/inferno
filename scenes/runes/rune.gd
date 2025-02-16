class_name Rune extends Node

@export var display_name: String
@export var icon: Texture
@export var effect_description: String
@export var stack_description: String
@export var cost: int

var is_in_deck: bool = false

enum Rarity {COMMON, UNCOMMON, RARE, LEGENDARY}

func activate():
	push_error("This Rune was activated without any behavior defined. It will do nothing.")
