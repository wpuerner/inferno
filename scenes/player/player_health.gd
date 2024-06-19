extends Node

@onready var event_bus: Node = get_node("/root/EventBus")

var health: int = 100:
	set(value):
		health = value
		event_bus.update_player_health(value)
		if health <= 0:
			get_parent().set_physics_process(false)
			event_bus.kill_player()

func _ready():
	event_bus.game_restarted.connect(func(): health = 100)

func apply_damage(amount: int):
	health -= amount
