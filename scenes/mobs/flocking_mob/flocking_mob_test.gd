extends Node2D

func _ready():
	for child in get_children():
		if child != $Target:
			child.target = $Target

func _physics_process(_delta):
	$Target.global_position = get_global_mouse_position()
