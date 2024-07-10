extends Area2D

@onready var event_bus: Node = get_node("/root/EventBus")

var rune: Rune

func _ready():
	event_bus.level_loaded.connect(func(): queue_free())

func _on_body_entered(_body):
	event_bus.pick_up_room_rune(rune)
