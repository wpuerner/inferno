extends Camera2D

var player: Node2D
var follow_speed = 10

func _physics_process(delta):
	if !is_instance_valid(player): return
	global_position = global_position.lerp(player.global_position, delta * follow_speed)
