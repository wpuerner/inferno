extends Node

var rune_scene_paths: PackedStringArray = [
	"res://scenes/runes/scatter_shot/scatter_shot.tscn",
	"res://scenes/runes/rapid_fire/rapid_fire.tscn",
	"res://scenes/runes/explosive/explosive.tscn"
]

func _ready():
	_generate_rune_pool()

func _generate_rune_pool():
	for i in 15:
		var rune_scene_path = rune_scene_paths[i % 3]
		var rune = load(rune_scene_path).instantiate()
		if get_child_count() < 8: rune.is_in_deck = true
		add_child(rune)

func get_deck() -> Array[Rune]:
	var runes: Array[Rune] = []
	for rune in get_children():
		if rune.is_in_deck:
			runes.append(rune)
	return runes
	
func get_runes():
	return get_children()
