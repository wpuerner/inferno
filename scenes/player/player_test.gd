extends Node2D


func _ready():
	$Player.global_position = get_viewport_rect().size / 2
