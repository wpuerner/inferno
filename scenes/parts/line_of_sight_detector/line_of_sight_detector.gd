extends Area2D

signal object_sighted(object: Node2D)
signal object_left_sight(object: Node2D)
signal object_left_range(object: Node2D)

@export_flags_2d_physics var ray_mask: int

@onready var event_bus: Node = get_node("/root/EventBus")

var objects: Array = []
var object_in_sight: Node2D

func _ready():
	set_physics_process(false)
	event_bus.gameplay_started.connect(func(): set_physics_process(true))

func _physics_process(_delta):
	if objects.is_empty(): return
	
	if is_instance_valid(object_in_sight):
		if _has_line_of_sight_to_object(object_in_sight):
			return
		else:
			object_left_sight.emit(object_in_sight)
			object_in_sight = null
	for object in objects:
		if _has_line_of_sight_to_object(object):
			object_sighted.emit(object)
			object_in_sight = object

func _has_line_of_sight_to_object(object: Node2D) -> bool:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(PhysicsRayQueryParameters2D.create(global_position, object.global_position, ray_mask))
	return result.has("collider") and result.collider == object

func _on_body_entered(body): 
	objects.append(body)

func _on_body_exited(body):
	if objects.has(body): objects.erase(body)
	if object_in_sight == body:
		object_left_range.emit(objects)
		object_in_sight = null
		
