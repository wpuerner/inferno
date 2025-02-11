extends Control

func _ready():
	$PrizeOverlay.was_completed.connect(func(): print_debug("Prize overlay was completed"))
	$PrizeOverlay.was_completed_with_rune.connect(func(rune: Rune): print_debug("Prize overlay was completed with rune ", rune.display_name))
	await get_tree().create_timer(0.5).timeout
	$PrizeOverlay.open()
