extends Node2D

func _ready():
	global_position = get_viewport_rect().size / 2
	$RuneCard.rune = $Rune

func _on_rune_card_selection_state_changed(rune, selected):
	print_debug("Rune card selection state was changed: ", rune, selected)
