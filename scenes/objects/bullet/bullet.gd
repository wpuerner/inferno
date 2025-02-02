extends Node2D

@export var spread_angle_attribute: Attribute

@onready var bullet_spawn_attribute: Attribute = ResourceLoader.load("res://scenes/attributes/bullet_spawn/bullet_spawn_attribute.tres")

const SPEED: float = 500

func _physics_process(delta: float):
	global_position += delta * Vector2(SPEED, 0).rotated(global_rotation)
	var params = PhysicsPointQueryParameters2D.new()
	params.collision_mask = 2  # Enemy layer
	params.position = global_position
	var results = get_world_2d().direct_space_state.intersect_point(params)
	var body: Node2D
	if !results.is_empty():
		body = results[0].collider
		if body:
			if bullet_spawn_attribute.get_value() != null:
				var spawn = load(bullet_spawn_attribute.get_value()).instantiate()
				spawn.global_position = global_position
				add_sibling.call_deferred(spawn)
			elif body.has_method("apply_damage"):
				body.apply_damage(1)
		queue_free()


func _draw():
	draw_circle(Vector2.ZERO, 1, Color.GREEN, true)
