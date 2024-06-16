extends Node

@export var fire_rate_attribute: Attribute
@export var automatic_fire_attribute: Attribute

@onready var event_bus: Node = get_node("/root/EventBus")
@onready var mana_handler: Node = get_node("/root/Main/ManaHandler")
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var player: Node2D = get_node("/root/Main").find_child("Player")

var spread_angle: float  #degrees
var num_bullets: int
var mana_cost: int
var timer: Timer

func _ready():
	_reset()
	event_bus.level_loaded.connect(_reset)
	event_bus.level_loaded.connect(func(): set_physics_process(false))
	event_bus.player_killed.connect(func(): set_physics_process(false))
	event_bus.gameplay_started.connect(func(): set_physics_process(true))
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
		
func _physics_process(_delta):
	if (timer.time_left > 0): return
	
	if (automatic_fire_attribute.get_value() and Input.is_action_pressed("primary")) or (!automatic_fire_attribute.get_value() and Input.is_action_just_pressed("primary")):
		for i in num_bullets:
			_fire_bullet()
		timer.start(60 / fire_rate_attribute.get_value())

func _fire_bullet():
	if !mana_handler.has_enough_mana(mana_cost): return
	mana_handler.decrease_mana(mana_cost)
	var bullet = preload("res://scenes/objects/bullet/bullet.tscn").instantiate()
	add_child(bullet)
	bullet.init(player.global_position)
	
func _reset():
	spread_angle = 0
	num_bullets = 1
	mana_cost = 10
