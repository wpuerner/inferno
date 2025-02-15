extends Node2D

@export var scan_shape: Shape2D

var remaining_jumps: int = 3
var used_targets: Array[Node2D] = []

func _ready():
	#  Only spawn lightning with 25% probability
	if randf() < 0.75: 
		queue_free()
		return
	var scan_origin: Vector2 = global_position
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	for n in range(0, remaining_jumps):
		var found_targets = _scan_for_targets(space_state, scan_origin)
		var filtered_targets = found_targets.filter(func(target): return !used_targets.has(target))
		if filtered_targets.size() == 0: break
		filtered_targets.sort_custom(func(a, b): return scan_origin.distance_to(a.global_position) < scan_origin.distance_to(b.global_position))
		var target = filtered_targets[0]
		used_targets.append(target)
		scan_origin = target.global_position
	for mob in used_targets:
		if mob.has_method("apply_damage"): mob.apply_damage(1)
	queue_redraw()
	await get_tree().create_timer(0.2).timeout
	queue_free()

func _scan_for_targets(space_state: PhysicsDirectSpaceState2D, origin: Vector2) -> Array:
	var params: PhysicsShapeQueryParameters2D = PhysicsShapeQueryParameters2D.new()
	params.collide_with_areas = true
	params.collision_mask = 2
	params.shape = scan_shape
	params.transform = Transform2D(0, origin)
	return space_state.intersect_shape(params).map(func(result): return result.collider)

func _draw():
	if used_targets.size() == 0: return
	var points = used_targets.map(func(target): return target.global_position - global_position)
	points.push_front(Vector2.ZERO)
	draw_polyline(points, Color.SKY_BLUE, 2)
