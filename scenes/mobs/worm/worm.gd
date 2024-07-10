extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var event_bus: Node = get_node("/root/EventBus")
@onready var bullet_spawn_attribute: Attribute = preload("res://scenes/attributes/bullet_spawn/bullet_spawn_attribute.tres")
@onready var spread_angle_attribute: Attribute = preload("res://scenes/attributes/spread_angle/spread_angle_attribute.tres")

var target: Node2D
var move_speed: float = 100.0
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var launch_speed: float = 1000.0
var drag: float = 0.80
var is_launching: bool = true

func _ready():
	event_bus.level_loaded.connect(func(): queue_free())
	animated_sprite_2d.play("idle")

func init():
	rng.randomize()
	var spread_angle = spread_angle_attribute.get_value()
	var angle = rng.randf_range(-spread_angle / 2, spread_angle / 2)
	velocity = launch_speed * Vector2.from_angle(global_position.angle_to_point(get_global_mouse_position()) + deg_to_rad(angle))

func _physics_process(_delta):
	if is_launching:
		velocity *= drag
		move_and_slide()
		if velocity.length() < 0.001:
			velocity = Vector2.ZERO
			is_launching = false
		return
	
	if is_instance_valid(target):
		navigation_agent.target_position = target.global_position
		velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * move_speed
		if velocity.x < 0: animated_sprite_2d.flip_h = true
		move_and_slide()

func _kill_worm():
	var spawn_path = bullet_spawn_attribute.get_value()
	if spawn_path != null:
		var spawn = load(spawn_path).instantiate()
		spawn.global_position = global_position
		add_sibling.call_deferred(spawn)
	queue_free()

func _on_trigger_area_body_entered(_body):
	_kill_worm()

func _on_line_of_sight_detector_object_sighted(object):
	target = object
	animated_sprite_2d.play("moving")

func _on_line_of_sight_detector_object_left_range(_object):
	target = null
	animated_sprite_2d.play("idle")
