extends Node

var rune_scene_paths: PackedStringArray = [
	"res://scenes/runes/scatter_shot/scatter_shot.tscn",
	"res://scenes/runes/rapid_fire/rapid_fire.tscn",
	"res://scenes/runes/explosive/explosive.tscn"
]
var hand: Array
var selected_runes: Array

func _ready():
	_generate_deck()

func _generate_deck():
	for i in 10:
		var rune_scene_path = rune_scene_paths[i % 2]
		var rune = load(rune_scene_path).instantiate()
		add_child(rune)

func get_hand() -> Array:
	for i in 5:
		hand.append(get_child(i))
	return hand

func activate_hand():
	for rune in selected_runes:
		rune.activate()
	selected_runes.clear()
	hand.clear()
	
func change_rune_selection_state(rune: Node, selected: bool):
	if selected:
		selected_runes.append(rune)
	elif !selected:
		selected_runes.erase(rune)
