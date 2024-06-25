extends CenterContainer

@onready var event_bus: Node = get_node("/root/EventBus")
@onready var new_runes_control: Control = find_child("NewRunesControl")

func _ready():
	event_bus.player_picked_up_room_rune.connect(_activate)
	
func _activate(rune: Rune):
	var rune_card = preload("res://scenes/runes/rune_card/rune_card.tscn").instantiate()
	rune_card.rune = rune
	new_runes_control.add_child(rune_card)
	visible = true

func _on_button_pressed():
	for child in new_runes_control.get_children():
		child.queue_free()
	event_bus.request_next_level()
	visible = false
