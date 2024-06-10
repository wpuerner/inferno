extends Node

func activate_menu():
	var main = get_node("/root/Main")
	if is_instance_valid(main): main.queue_free()
	get_tree().root.add_child(preload("res://scenes/main_menu.tscn").instantiate())
	
func activate_game():
	var menu = get_node("/root/MainMenu")
	if is_instance_valid(menu): menu.queue_free()
	get_tree().root.add_child(preload("res://scenes/main.tscn").instantiate())
