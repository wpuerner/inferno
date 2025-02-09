extends CharacterBody2D

signal was_killed
signal health_was_changed(new_amount: int)

var can_fire: bool = true
var health: int = 8

const MAX_SPEED: float = 100
const ACCELERATION: float = 500
const DECELERATION: float = 700

func apply_damage(amount: int):
	if health <= 0: return
	health -= amount
	health_was_changed.emit(health)
	if health <= 0:
		was_killed.emit()
		queue_redraw()
		set_physics_process(false)
		$OnDeathAnimation.visible = true
		$OnDeathAnimation.play("default")
		await $OnDeathAnimation.animation_finished
		$OnDeathAnimation.visible = false
		

func _physics_process(delta: float):
	var direction_x: float = Input.get_axis("move_left", "move_right")
	var direction_y: float = Input.get_axis("move_up", "move_down")
	var direction: Vector2 = Vector2(direction_x, direction_y).normalized()
	if direction.length() > 0:
		velocity = velocity.move_toward(direction * MAX_SPEED, delta * ACCELERATION)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * DECELERATION)
	move_and_slide()
	
	global_rotation = global_position.angle_to_point(get_global_mouse_position())
	
	if Input.is_action_pressed("primary_fire") and can_fire: _fire_bullet()

func _draw():
	if health > 0:
		draw_polyline([Vector2(-20, -20), Vector2(0, 0), Vector2(-20, 20)], Color.GREEN, 5, true)

func _fire_bullet():
	var bullet = preload("res://scenes/objects/bullet/bullet.tscn").instantiate()
	bullet.global_rotation = global_rotation
	bullet.global_position = global_position
	add_sibling(bullet)
	can_fire = false
	$FireTimer.start(0.2)

func _on_fire_timer_timeout():
	can_fire = true
