extends CharacterBody2D

# Forward will be the positive x axis to make angle_to_point easier to process

const STEERING_FORCE: float = 3.0
const SEPARATION_FACTOR: float = 100.0
const VIEW_ANGLE: float = 0.50 * PI  # The angle on either side of the forward axis where neighbors are visible
const MOVE_SPEED: float = 80.0

var target: Node2D
var close_peers: Array[Node2D] = []

func _physics_process(delta: float):
	if target == null:
		return
	
	var steering_force: float = 0.0
	
	var visible_peers: Array[Node2D] = []
	for peer in close_peers:
		var peer_position = peer.global_position - global_position  # relative position to this body
		peer_position = peer_position.rotated(-global_rotation)
		if abs(peer_position.angle()) < VIEW_ANGLE:
			visible_peers.append(peer)
			
			# correct for separation
			if peer_position.length() <= velocity.length() * SEPARATION_FACTOR:
				var m = 1 if peer_position.y < 0 else -1
				steering_force += m * STEERING_FORCE * SEPARATION_FACTOR / peer_position.length()

	if !visible_peers.is_empty():
		var average_peer_position: Vector2 = visible_peers \
			.map(func(peer): return peer.global_position) \
			.reduce(func(sum_position: Vector2, peer_position: Vector2): return sum_position + peer_position) \
			 / visible_peers.size()
		var relative_peer_position = average_peer_position - global_position
		relative_peer_position = relative_peer_position.rotated(-global_rotation)
		steering_force += STEERING_FORCE * relative_peer_position.angle() / PI
	else:
		var target_relative_position = target.global_position - global_position
		target_relative_position = target_relative_position.rotated(-global_rotation)
		steering_force += STEERING_FORCE * target_relative_position.angle() / PI

	# average the computed rotations for the global rotation
	global_rotation += delta * steering_force
	velocity = Vector2(MOVE_SPEED, 0).rotated(global_rotation)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D):
	if body == self: return
	close_peers.append(body)

func _on_area_2d_body_exited(body: Node2D):
	close_peers.erase(body)

func _get_correction_angle(from_angle: float, to_angle: float):
	var direction: float = 1.0 if from_angle > to_angle else -1.0
	while abs(from_angle - to_angle) > PI:
		to_angle += direction * 2 * PI
	return to_angle - from_angle
