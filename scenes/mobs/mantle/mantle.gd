extends StaticBody2D

@onready var charge_timer: Timer = $ChargeTimer
@onready var attack_timer: Timer = $AttackTimer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var event_bus: Node = get_node("/root/EventBus")

var player: Node2D
var target_position: Vector2

func _ready():
	animated_sprite.play("idle")

func _on_entity_health_health_was_depleated():
	animated_sprite.play("dieing")
	animated_sprite.reparent(get_parent())
	event_bus.kill_mob(self)
	queue_free()

func _on_line_of_sight_detector_object_sighted(object):
	player = object
	charge_timer.start()

func _on_line_of_sight_detector_object_left_sight(object):
	player = null
	if animated_sprite.animation != "idle": animated_sprite.play("idle")
	charge_timer.stop()

func _on_charge_timer_timeout():
	if is_instance_valid(player):
		animated_sprite.play("attacking")
		target_position = player.global_position
		attack_timer.start()
		
func _on_animated_sprite_2d_animation_finished():
	if animated_sprite.animation == "attacking":
		animated_sprite.play("idle")
	if is_instance_valid(player):
		charge_timer.start()

func _on_attack_timer_timeout():
	var fireball = preload("res://scenes/objects/fireball/fireball.tscn").instantiate()
	fireball.global_position = global_position
	fireball.global_rotation = global_position.angle_to_point(target_position)
	add_sibling(fireball)
