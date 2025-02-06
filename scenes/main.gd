extends Node2D

@onready var hand: Node2D = find_child("Hand")

func _ready():
	$HandCanvasLayer.find_child("Hand").position = get_viewport_rect().size / 2
	$HandCanvasLayer.visible = true
	hand.open_with_runes($RunePool.get_hand())

func _on_play_button_pressed():
	$HandCanvasLayer.visible = false
