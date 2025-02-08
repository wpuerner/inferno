extends Node2D

func _ready():
	$Hand.global_position = get_viewport_rect().size / 2
	
	var runes: Array[Rune] = []
	for child in $Runes.get_children():
		if child is Rune:
			runes.append(child as Rune)
	$Hand.open_with_runes(runes)
	await get_tree().create_timer(3.0).timeout
	$Hand.close()
