extends Node2D

func _ready():
	$Player.was_killed.connect(func(): print_debug("Player was killed!"))
	$Player.health_was_changed.connect(func(new_amount): print_debug("New player health: ", new_amount))
