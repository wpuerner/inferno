extends Panel

signal selection_state_changed(rune: Rune, selected: bool)

@onready var title_label: Label = find_child("TitleLabel")
@onready var description_label: Label = find_child("DescriptionLabel")
@onready var rune_texture: TextureRect = find_child("TextureRect")

var is_hovered: bool = false
var is_selected: bool = false:
	set(value):
		is_selected = value
		modulate = Color.SKY_BLUE if is_selected else Color.WHITE
var default_position: Vector2
var tween: Tween
var rune: Rune
var is_selectable: bool = false:
	set(value):
		is_selectable = value
		mouse_filter = Control.MOUSE_FILTER_STOP if is_selectable else Control.MOUSE_FILTER_IGNORE

func deselect():
	is_selected = false

func _ready():
	pivot_offset = Vector2(size.x / 2, size.y / 2)
	_generate()

func _on_mouse_entered():
	if !is_selectable: return
	is_hovered = true
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.1)
	
func _on_mouse_exited():
	if !is_selectable: return
	is_hovered = false
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.1)

func _input(event: InputEvent):
	if !is_selectable: return
	if !event.is_action_pressed("primary"): return
	if is_hovered: _toggle_selection_state()

func _toggle_selection_state():
	is_selected = !is_selected
	selection_state_changed.emit(rune, is_selected)

func _generate():
	if !rune: return
	title_label.text = rune.display_name
	rune_texture.texture = rune.texture
	var description_string: String = ""
	description_label.text = " ".join(rune.get_modifier_display_names())
	modulate = Color.SKY_BLUE if is_selected else Color.WHITE
