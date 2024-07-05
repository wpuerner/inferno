extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var event_bus: Node = get_node("/root/EventBus")
@onready var rune_pool: Node = get_node("/root/RunePool")
@onready var hand_control: Control = find_child("Hand")
@onready var deck_control: Control = find_child("Deck")
@onready var discard_control: Control = find_child("Discard")
@onready var added_runes_container: Node = $AddedRunesContainer

var hand: Array[Rune]
var selected_runes: Array[Rune]
var deck: Array[Rune]
var discard: Array[Rune]
var rune_to_card_map = {}

func get_added_runes():
	return added_runes_container.get_children()
	
func send_rune_to_rune_pool(rune: Rune):
	_remove_rune_from_deck(rune)
	_remove_rune_from_discard(rune)
	rune_to_card_map[rune].queue_free()
	added_runes_container.remove_child(rune)
	rune_pool.add_rune(rune)

func _ready():
	event_bus.game_restarted.connect(_shuffle)
	event_bus.pre_level_started.connect(_open_hand)
	event_bus.player_picked_up_room_rune.connect(_handle_picked_up_rune)
	for rune in rune_pool.get_deck():
		_add_rune_to_deck(rune)
	_shuffle()

func _on_show_deck_control_mouse_entered():
	animation_player.play("open_deck_display")

func _on_deck_display_mouse_exited():
	animation_player.play("close_deck_display")


func _on_show_discard_control_mouse_entered():
	animation_player.play("open_discard_display")


func _on_discard_display_mouse_exited():
	animation_player.play("close_discard_display")

func _shuffle():
	for rune in discard:
		_remove_rune_from_discard(rune)
		_add_rune_to_deck(rune)
	deck.shuffle()

func _open_hand():
	for i in 5:
		if deck.is_empty(): _shuffle()
		var rune = deck.front()
		if rune == null: break
		_remove_rune_from_deck(rune)
		_add_rune_to_hand(rune)
	visible = true

func _on_button_pressed():
	visible = false
	_activate_hand()
	event_bus.activate_hand()

func _activate_hand():
	while !hand.is_empty():
		var rune = hand.front()
		if rune_to_card_map[rune].is_selected: rune.activate()
		_remove_rune_from_hand(rune)
		_add_rune_to_discard(rune)
	selected_runes.clear()

func _get_or_create_card(rune: Rune) -> Control:
	if rune_to_card_map.has(rune): return rune_to_card_map[rune]
	var card = preload("res://scenes/runes/rune_card/rune_card.tscn").instantiate()
	card.rune = rune
	rune_to_card_map[rune] = card
	return card

func _handle_picked_up_rune(rune: Rune):
	added_runes_container.add_child(rune)
	_add_rune_to_discard(rune)

func _add_rune_to_deck(rune: Rune):
	deck.append(rune)
	var card = _get_or_create_card(rune)
	card.is_selected = false
	card.is_selectable = false
	deck_control.add_child(card)
	
func _remove_rune_from_deck(rune: Rune):
	if not deck.has(rune): return
	deck.erase(rune)
	deck_control.remove_child(rune_to_card_map[rune])
	
func _add_rune_to_hand(rune: Rune):
	hand.append(rune)
	var card = _get_or_create_card(rune)
	card.is_selected = false
	card.is_selectable = true
	hand_control.add_child(card)
	
func _remove_rune_from_hand(rune: Rune):
	hand.erase(rune)
	hand_control.remove_child(rune_to_card_map[rune])
	
func _add_rune_to_discard(rune: Rune):
	discard.append(rune)
	var card = _get_or_create_card(rune)
	card.is_selected = false
	card.is_selectable = false
	discard_control.add_child(card)
	
func _remove_rune_from_discard(rune: Rune):
	if not discard.has(rune): return
	discard.erase(rune)
	discard_control.remove_child(rune_to_card_map[rune])
