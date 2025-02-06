extends Node2D

func _ready():
	for child in get_children():
		if child != $Target:
			child.target = $Target
			child.global_position = Vector2(randf_range(0, get_viewport_rect().size.x), randf_range(0, get_viewport_rect().size.y))

func _physics_process(_delta):
	$Target.global_position = get_global_mouse_position()
