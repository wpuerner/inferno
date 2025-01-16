extends Node2D

@onready var event_bus: Node = get_node("/root/EventBus")
@onready var player: Node2D = $Player
@onready var level: Node = $Level

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var level_number: int = 1

func _ready():
	event_bus.game_restarted.connect(_restart_game)
	event_bus.player_requested_next_level.connect(_switch_levels)
	event_bus.player_activated_hand.connect(_start_gameplay)
	_load_level()
	$GameCamera.player = $Player

func _load_level():
	find_child("LevelNumberLabel").text = str(level_number)
	event_bus.load_level()
	_start_pre_level()

func _start_pre_level():
	event_bus.start_pre_level()
	
func _start_gameplay():
	event_bus.start_gameplay()
	
func _switch_levels():
	level_number += 1
	_load_level()

func _restart_game():
	level_number = 1
	_load_level()
