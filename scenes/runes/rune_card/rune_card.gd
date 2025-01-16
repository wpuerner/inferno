extends Area2D

signal selection_state_changed(rune: Rune, selected: bool)

var is_selected: bool = false:
	set(value):
		is_selected = value
		selection_state_changed.emit(rune, is_selected)
var rune: Rune:
	set(value):
		rune = value
		$Panel/TextureRect.texture = rune.icon
		$InfoPanel.find_child("DisplayNameLabel").text = rune.display_name
		$InfoPanel.find_child("EffectDescriptionLabel").text = rune.effect_description
		if !rune.stack_description.is_empty():
			var label: Label = $InfoPanel.find_child("StackDescriptionLabel")
			label.visible = true
			label.text = rune.stack_description

func _on_mouse_entered():
	$InfoPanel.visible = true
	
func _on_mouse_exited():
	$InfoPanel.visible = false

func _on_input_event(_viewport, event: InputEvent, _shape_idx):
	if !event.is_action_pressed("primary"): return
	is_selected = !is_selected
