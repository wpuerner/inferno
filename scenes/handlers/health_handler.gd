extends Node

@onready var health_bar: ProgressBar = get_node("/root/Main").find_child("HealthBar")
@onready var player: Node2D = get_node("/root/Main").find_child("Player")
@onready var event_bus: Node = get_node("/root/EventBus")

var health: int = 100:
	set(value):
		health = value
		health_bar.value = health
		if health <= 0:
			_kill_player()

func _ready():
	event_bus.game_restarted.connect(func(): health = 100)

func apply_damage(amount: int):
	health -= amount

func _kill_player():
	player.set_physics_process(false)
	event_bus.kill_player()
