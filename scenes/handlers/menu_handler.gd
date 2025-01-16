extends Node

func activate_menu():
	var current_node: Node
	if has_node("/root/Main"):
		current_node = get_node("/root/Main")
	elif has_node("/root/DeckSelector"):
		current_node = get_node("/root/DeckSelector")
	current_node.queue_free()
	get_tree().root.add_child(preload("res://scenes/main_menu.tscn").instantiate())
	
func activate_game():
	var menu = get_node("/root/MainMenu")
	if is_instance_valid(menu): menu.queue_free()
	get_tree().root.add_child(preload("res://scenes/main.tscn").instantiate())

func activate_deck_selector():
	var menu = get_node("/root/MainMenu")
	if is_instance_valid(menu): menu.queue_free()
	#get_tree().root.add_child(preload("res://scenes/menu/deck_selector/deck_selector.tscn").instantiate())
