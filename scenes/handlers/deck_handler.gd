extends Node

@onready var event_bus: Node = get_node("/root/EventBus")
@onready var main: Node = get_node("/root/Main")
@onready var hand_control: Control = find_child("Hand")
@onready var hand_container: Control = find_child("HandContainer")

var rune_scene_paths: PackedStringArray = [
	"res://scenes/runes/scatter_shot/scatter_shot.tscn",
	"res://scenes/runes/rapid_fire/rapid_fire.tscn",
	"res://scenes/runes/explosive/explosive.tscn"
]
var hand: Array[Rune]
var selected_runes: Array[Rune]
var deck: Array[Rune]
var discard: Array[Rune]

func _ready():
	event_bus.game_restarted.connect(_shuffle)
	event_bus.pre_level_started.connect(_open_hand)
	_generate_deck()

func _generate_deck():
	for i in 10:
		var rune_scene_path = rune_scene_paths[i % 3]
		var rune = load(rune_scene_path).instantiate()
		add_child(rune)
		deck.append(rune)
	_shuffle()
		
func _shuffle():
	deck.append_array(discard)
	discard.clear()
	deck.shuffle()

func _open_hand():
	for i in 5:
		if deck.is_empty(): _shuffle()
		var rune = deck.pop_back()
		hand.append(rune)
		var rune_card = preload("res://scenes/runes/rune_card/rune_card.tscn").instantiate()
		hand_control.add_child(rune_card)
		rune_card.selection_state_changed.connect(_change_rune_selection_state)
		rune_card.rune = rune
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
