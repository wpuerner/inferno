extends CenterContainer

@export var hand_interface: Node

@onready var event_bus: Node = get_node("/root/EventBus")
@onready var main: Node = get_node('/root/Main')
@onready var new_runes_interface: Control = find_child("NewRunesInterface")
@onready var new_runes_control: Control = find_child("NewRunesControl")
@onready var save_rune_interface: Control = find_child("SaveRuneInterface")
@onready var save_rune_control: Control = find_child("SaveRuneControl")

var currently_selected_save_rune: Rune
var rune_to_card_map = {}

func _ready():
	event_bus.player_picked_up_room_rune.connect(_activate)
	
func _activate(rune: Rune):
	var rune_card = preload("res://scenes/runes/rune_card/rune_card.tscn").instantiate()
	rune_card.rune = rune
	new_runes_control.add_child(rune_card)
	visible = true
	new_runes_interface.visible = true

func _on_button_pressed():
	for child in new_runes_control.get_children():
		child.queue_free()
	new_runes_interface.visible = false
	if main.level_number >= 5 and main.level_number % 5 == 0:
		_activate_save_rune_interface()
	else:
		_complete()

func _activate_save_rune_interface():
	var runes = hand_interface.get_added_runes()
	for rune in runes:
		var card = preload("res://scenes/runes/rune_card/rune_card.tscn").instantiate()
		card.rune = rune
		card.is_selectable = true
		card.selection_state_changed.connect(_handle_save_rune_card_selected)
		save_rune_control.add_child(card)
		rune_to_card_map[rune] = card
	save_rune_interface.visible = true
		
func _handle_save_rune_card_selected(rune: Rune, selected: bool):
	if not selected:
		currently_selected_save_rune = null
	else:
		if is_instance_valid(currently_selected_save_rune):
			rune_to_card_map[currently_selected_save_rune].deselect()
		currently_selected_save_rune = rune

func _on_save_rune_button_pressed():
	if is_instance_valid(currently_selected_save_rune):
		hand_interface.send_rune_to_rune_pool(currently_selected_save_rune)
	save_rune_interface.visible = false
	_complete()
	
func _complete():
	for child in save_rune_control.get_children():
		child.queue_free()
	event_bus.request_next_level()
	visible = false
