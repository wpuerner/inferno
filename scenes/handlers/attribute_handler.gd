extends Node

# Manages lifecycle of Resource based Attributes

@export var attributes: Array[Attribute]

@onready var event_bus: Node = get_node("/root/EventBus")

func _ready():
	event_bus.level_loaded.connect(_reset_all_attributes)
	
func _reset_all_attributes():
	for attribute in attributes:
		attribute.reset()
