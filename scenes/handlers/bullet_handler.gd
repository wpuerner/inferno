extends Node

@export var fire_rate_attribute: Attribute
@export var automatic_fire_attribute: Attribute
@export var num_bullets_attribute: Attribute
@export var projectile_attribute: Attribute = preload("res://scenes/attributes/projectile/projectile_attribute.tres")

@onready var spread_angle_attribute: Attribute = preload("res://scenes/attributes/spread_angle/spread_angle_attribute.tres")
@onready var event_bus: Node = get_node("/root/EventBus")
@onready var mana_handler: Node = get_node("/root/Main/ManaHandler")
@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new()
@onready var player: Node2D = get_node("/root/Main").find_child("Player")

var mana_cost: int
var timer: Timer

func _ready():
	_reset()
	event_bus.level_loaded.connect(_reset)
	event_bus.level_loaded.connect(func(): set_physics_process(false))
	event_bus.player_killed.connect(func(): set_physics_process(false))
	event_bus.player_picked_up_room_rune.connect(func(_rune): set_physics_process(false))
	event_bus.gameplay_started.connect(func(): set_physics_process(true))
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
		
func _physics_process(_delta):
	if (timer.time_left > 0): return
	if (automatic_fire_attribute.get_value() and Input.is_action_pressed("primary")) or (!automatic_fire_attribute.get_value() and Input.is_action_just_pressed("primary")):
		var direction = player.global_position.angle_to_point(player.get_global_mouse_position())
		if num_bullets_attribute.get_value() == 1:
			_fire_bullet(direction)
		else:
			for i in num_bullets_attribute.get_value():
				_fire_bullet(direction + deg_to_rad(-0.5 * spread_angle_attribute.get_value() + (spread_angle_attribute.get_value() / (num_bullets_attribute.get_value() - 1)) * (i - 1)))
		timer.start(60 / fire_rate_attribute.get_value())

func _fire_bullet(direction: float):
	if !mana_handler.has_enough_mana(mana_cost): return
	mana_handler.decrease_mana(mana_cost)
	var bullet = projectile_attribute.get_value().instantiate()
	bullet.global_position = player.global_position
	add_child(bullet)
	if bullet.has_method("init"): bullet.init(direction)
	
func _reset():
	mana_cost = 10
