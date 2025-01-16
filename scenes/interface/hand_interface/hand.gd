extends Node2D

const SEPARATION: int = 200

func add_rune(rune: Rune):
	var rune_card = preload("res://scenes/runes/rune_card/rune_card.tscn").instantiate()
	rune_card.rune = rune
	add_child(rune_card)
	for n in range(0, get_child_count()):
		var child: Node2D = get_children()[n]
		child.position = Vector2(_get_x_position(n), 0)

func _get_x_position(index: int):
	var num_cards = get_child_count()
	var hand_width = (num_cards - 1) * SEPARATION
	return (-0.5 * hand_width) + SEPARATION * (index - 1)
