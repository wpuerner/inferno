extends Node

@onready var event_bus: Node = get_node("/root/EventBus")
@onready var main: Node = get_node("/root/Main")
@onready var skull_spawner: PathFollow2D = main.find_child("SkullSpawner")

var enemy_container: Node
var timer: Timer
var check_enemy_timer: Timer
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var speed: float = 500
var energy: int
var skull_energy: int = 100
var spawn_rate: float  #skulls per second. Aim for 60s spawning duration

func _ready():
	enemy_container = Node.new()
	add_child(enemy_container)
	event_bus.gameplay_started.connect(_start_spawning)
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_spawn)

	check_enemy_timer = Timer.new()
	add_child(check_enemy_timer)
	check_enemy_timer.timeout.connect(_check_enemies)

func _start_spawning():
	energy = main.level_number * 100
	spawn_rate = (energy / skull_energy) 
	timer.start(_get_spawn_interval())
	check_enemy_timer.start(2)
	
func _stop_spawning():
	timer.stop()
	
func _spawn():
	var skull = preload("res://scenes/mobs/skull/skull.tscn").instantiate()
	enemy_container.add_child(skull)
	skull.global_position = skull_spawner.global_position
	energy -= skull_energy
	if energy <= 0:
		_stop_spawning()
		return
	timer.start(_get_spawn_interval())

func _get_spawn_interval():
	return rng.randf_range((1 / spawn_rate) / 2, (1 / spawn_rate) * 2)

func _check_enemies():
	if energy <= 0 && enemy_container.get_child_count() == 0:
		check_enemy_timer.stop()
		main.open_exit()
