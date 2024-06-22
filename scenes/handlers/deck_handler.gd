extends Node

@onready var event_bus: Node = get_node("/root/EventBus")
@onready var main: Node = get_node("/root/Main")
@onready var rune_pool: Node = get_node("/root/RunePool")
@onready var hand_control: Control = main.find_child("Hand")
@onready var hand_container: Control = main.find_child("HandContainer")

var hand: Array[Rune]
var selected_runes: Array[Rune]
var deck: Array[Rune]
var discard: Array[Rune]

func _ready():
	event_bus.game_restarted.connect(_shuffle)
	event_bus.pre_level_started.connect(_open_hand)
	deck = rune_pool.get_deck()
	_shuffle()

func _shuffle():
	deck.append_array(discard)
	discard.clear()
	deck.shuffle()

func _open_hand():
	for i in 5:
		if deck.is_empty(): _shuffle()
		var rune = deck.pop_back()
		if rune == null: break
		hand.append(rune)
		var rune_card = preload("res://scenes/runes/rune_card/rune_card.tscn").instantiate()
		rune_card.selection_state_changed.connect(_change_rune_selection_state)
		rune_card.rune = rune
		hand_control.add_child(rune_card)
	hand_container.visible = true
		
func _on_button_pressed():
	_activate_hand()
	hand_container.visible = false
	for child in hand_control.get_children():
		child.queue_free()
	main.start_gameplay()

func _activate_hand():
	for rune in selected_runes:
		rune.activate()
	selected_runes.clear()
	discard.append_array(hand)
	hand.clear()
	
func _change_rune_selection_state(rune: Rune, selected: bool):
	if selected:
		selected_runes.append(rune)
	elif !selected:
		selected_runes.erase(rune)
