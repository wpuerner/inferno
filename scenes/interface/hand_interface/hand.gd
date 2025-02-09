extends Node2D

signal was_closed

@export var capacity_label: Label

@onready var deck_global_position: Vector2 = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y + 200)

const SEPARATION: int = 200
const MAX_CAPACITY: int = 4

var selected_cards: Array[RuneCard] = []

func activate():
	for card in selected_cards:
		card.rune.activate()

func open_with_runes(runes: Array[Rune]):
	_update_capacity_label()
	for rune in runes:
		add_rune(rune)
		await get_tree().create_timer(0.2).timeout

func add_rune(rune: Rune):
	var rune_card = preload("res://scenes/runes/rune_card/rune_card.tscn").instantiate()
	add_child(rune_card)
	rune_card.rune = rune
	rune_card.global_position = deck_global_position
	rune_card.was_selected.connect(_rune_card_was_selected.bind(rune_card))
	for n in range(0, get_child_count()):
		var child: Node2D = get_children()[n]
		var new_position: Vector2 = Vector2(_get_x_position(n), 0)
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(child, "position", new_position, 0.1).set_ease(Tween.EASE_OUT)

func get_selected_runes() -> Array[Rune]:
	var runes: Array[Rune] = []
	for card in selected_cards:
		runes.append(card.rune)
	return runes

func close():
	selected_cards.clear()
	while get_child_count() > 0:
		var child: Node2D = get_children()[0]
		var tween: Tween = get_tree().create_tween()
		tween.tween_property(child, "global_position", deck_global_position, 0.1)
		tween.tween_callback(child.queue_free)
		await get_tree().create_timer(0.1).timeout
	was_closed.emit()

func _get_x_position(index: int):
	var num_cards = get_child_count()
	var hand_width = (num_cards - 1) * SEPARATION
	var value = (-0.5 * hand_width) + SEPARATION * index
	return value

func _rune_card_was_selected(rune_card: Node2D):
	var y_pos: int = 0
	if selected_cards.has(rune_card):
		selected_cards.erase(rune_card)
	elif _hand_cost() + rune_card.rune.cost <= MAX_CAPACITY:
		selected_cards.append(rune_card)
		y_pos = -100
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(rune_card, "position", Vector2(rune_card.position.x, y_pos), 0.1)
	_update_capacity_label()
		
func _hand_cost() -> int:
	if selected_cards.is_empty(): return 0
	var sum: int = 0
	for card in selected_cards:
		sum += card.rune.cost
	return sum

func _update_capacity_label():
	capacity_label.text = str(_hand_cost(), " / ", MAX_CAPACITY)
