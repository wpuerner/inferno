extends Area2D

signal object_sighted(object: Node2D)
signal object_left_range(object: Node2D)

var objects: Array = []
var object_in_sight: Node2D

func _physics_process(_delta):
	if objects.is_empty(): return
	if is_instance_valid(object_in_sight): return
	for object in objects:
		var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		var params: PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(global_position, object.global_position)
		if space_state.intersect_ray(params).collider == object:
			object_sighted.emit(object)
			object_in_sight = object

func _on_body_entered(body): 
	objects.append(body)

func _on_body_exited(body):
	if objects.has(body): objects.erase(body)
	if object_in_sight == body:
		object_left_range.emit(objects)
		object_in_sight = null
		
