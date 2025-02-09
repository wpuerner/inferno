class_name RuneCard extends Area2D

signal was_selected

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
		$Panel/CostLabel.text = str(rune.cost)

func _on_mouse_entered():
	$InfoPanel.visible = true
	
func _on_mouse_exited():
	$InfoPanel.visible = false

func _on_input_event(_viewport, event: InputEvent, _shape_idx):
	if !event.is_action_pressed("select_rune"): return
	was_selected.emit()
