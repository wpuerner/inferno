extends Node

@onready var event_bus: Node = get_node("/root/EventBus")
@onready var main: Node = get_node("/root/Main")
@onready var skull_spawner: PathFollow2D = main.find_child("SkullSpawner")

var enemy_container: Node
var timer: Timer
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var speed: float = 500
var energy: int
var skull_energy: int = 100
var spawn_rate: float  #skulls per second. Aim for 60s spawning duration
var dont_check_enemies: bool = false

func _ready():
	event_bus.player_killed.connect(_clear_enemies)
	event_bus.player_killed.connect(_stop_spawning)
	event_bus.gameplay_started.connect(_start_spawning)
	
	enemy_container = Node.new()
	add_child(enemy_container)
	
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_spawn)

func _start_spawning():
	dont_check_enemies = false
	energy = main.level_number * 100
	spawn_rate = (energy / skull_energy) 
	timer.start(_get_spawn_interval())
	
func _stop_spawning():
	timer.stop()
	
func _spawn():
	var skull = preload("res://scenes/mobs/skull/skull.tscn").instantiate()
	enemy_container.add_child(skull)
	skull.global_position = skull_spawner.global_position
	skull.tree_exited.connect(_check_enemies)
	energy -= skull_energy
	if energy <= 0:
		_stop_spawning()
		return
	timer.start(_get_spawn_interval())

func _get_spawn_interval():
	return rng.randf_range((1 / spawn_rate) / 2, (1 / spawn_rate) * 2)

func _check_enemies():
	if dont_check_enemies: return
	if energy <= 0 && enemy_container.get_child_count() == 0:
		main.open_exit()
		
func _clear_enemies():
	dont_check_enemies = true
	for enemy in enemy_container.get_children():
		enemy.queue_free()
