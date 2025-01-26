extends CharacterBody2D

# Forward will be the positive x axis to make angle_to_point easier to process

const STEERING_FORCE: float = 1.0
const SEPARATION_FACTOR: float = 1.0
const VIEW_ANGLE: float = 0.25 * PI  # The angle on either side of the forward axis where neighbors are visible
const MOVE_SPEED: float = 20.0

var target: Node2D
var close_peers: Array[Node2D] = []

func _physics_process(_delta):
	if target == null:
		return
	
	var visible_peers: Array[Node2D] = []
	for peer in close_peers:
		var peer_position = peer.global_position - global_position  # relative position to this body
		peer_position = peer_position.rotated(-global_rotation)
		if abs(peer_position.angle()) < VIEW_ANGLE:
			visible_peers.append(peer)
		
		# separation

	var steering_force: float = 0
	if !visible_peers.is_empty():
		var average_peer_position: Vector2 = visible_peers \
			.map(func(peer): return peer.global_position) \
			.reduce(func(sum_position: Vector2, peer_position: Vector2): return sum_position + peer_position) \
			 / visible_peers.size()
		average_peer_position = average_peer_position.rotated(-global_rotation)
		steering_force += -1 * STEERING_FORCE * average_peer_position.angle() / PI  # apply steering force towards the center of the visible neighbors

	# alignment	
	
	# add steering force of target
	var target_position = (target.global_position).rotated(-global_rotation)
	steering_force += -1 * STEERING_FORCE * target_position.angle() / PI
	
	# move this body
	velocity = Vector2(MOVE_SPEED, 0).rotated(global_rotation * steering_force)
	move_and_slide()

func _on_area_2d_body_entered(body: Node2D):
	if body == self: return
	close_peers.append(body)

func _on_area_2d_body_exited(body: Node2D):
	close_peers.erase(body)
