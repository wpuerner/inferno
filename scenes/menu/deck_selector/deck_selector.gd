extends Node

@onready var menu_handler: Node = get_node("/root/MenuHandler")
@onready var rune_pool: Node = get_node("/root/RunePool")
@onready var runes = rune_pool.get_runes()
@onready var deck_control: Control = find_child("Deck")
@onready var rune_pool_control: Control = find_child("RunePool")
@onready var rune_count_label: Label = find_child("RuneCountLabel")

var rune_to_pool_map = {}
var rune_to_deck_map = {}
var max_rune_count: int = 8

func _ready():
	for rune in runes:
		var rune_card: Control = preload("res://scenes/runes/rune_card/rune_card.tscn").instantiate()
		rune_card.rune = rune
		rune_to_pool_map[rune] = rune_card
		rune_card.selection_state_changed.connect(_handle_rune_pool_selection)
		rune_pool_control.add_child(rune_card)
		if rune.is_in_deck:
			rune_card.is_selected = true
			_add_rune_to_deck(rune)

func _handle_rune_pool_selection(rune: Rune, selected):
	if selected and deck_control.get_child_count() >= max_rune_count:
		rune_to_pool_map[rune].is_selected = false
	elif selected:
		_add_rune_to_deck(rune)
	else:
		_remove_rune_from_deck(rune)

func _add_rune_to_deck(rune: Rune):
	rune.is_in_deck = true
	var deck_card: Control = preload("res://scenes/runes/rune_card/rune_card.tscn").instantiate()
	deck_card.rune = rune
	rune_to_deck_map[rune] = deck_card
	deck_control.add_child(deck_card)
	_update_rune_count_label(deck_control.get_child_count())

func _remove_rune_from_deck(rune: Rune):
	rune.is_in_deck = false
	rune_to_deck_map[rune].queue_free()
	_update_rune_count_label(deck_control.get_child_count()-1)

func _update_rune_count_label(count: int):
	rune_count_label.text = str(count) + " / " + str(max_rune_count)

func _on_back_button_pressed():
	if deck_control.get_child_count() < max_rune_count:
		for i in 3:
			rune_count_label.add_theme_constant_override("outline_size", 8)
			await get_tree().create_timer(0.5).timeout
			rune_count_label.remove_theme_constant_override("outline_size")
			await get_tree().create_timer(0.5).timeout
	else:
		menu_handler.activate_menu()
