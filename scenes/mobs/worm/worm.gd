extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D
@onready var bullet_spawn_attribute: Attribute = preload("res://scenes/attributes/bullet_spawn/bullet_spawn_attribute.tres")

var target: Node2D
var move_speed: float = 100.0

func _physics_process(delta: float):
	if !is_instance_valid(target): 
		if animated_sprite_2d.is_playing():
			animated_sprite_2d.stop()
			animated_sprite_2d.frame = 0
		return
	var collision: KinematicCollision2D = get_last_slide_collision()
	if collision != null:
		_kill_worm()
	navigation_agent.target_position = target.global_position
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * move_speed
	if velocity.x < 0: animated_sprite_2d.flip_h = true
	move_and_slide()

func _on_detection_area_body_entered(body: Node2D):
	if !is_instance_valid(target): 
		target = body
		animated_sprite_2d.play()

func _kill_worm():
	var spawn_path = bullet_spawn_attribute.get_value()
	if spawn_path != null:
		var spawn = load(spawn_path).instantiate()
		spawn.global_position = global_position
		add_sibling.call_deferred(spawn)
	queue_free()
