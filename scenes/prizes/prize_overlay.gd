extends CenterContainer

signal was_completed
signal was_completed_with_rune(rune: Rune)

const RUNES = \
[preload("res://scenes/runes/health_up/health_up.tscn"), \
preload("res://scenes/runes/fire_rate_up/fire_rate_up.tscn"), \
preload("res://scenes/runes/number_projectiles_up/number_projectiles_up.tscn")]
const PRIZE_SIZE: int = 3

func open():
	for n in range(0, PRIZE_SIZE):
		var prize_card = preload("res://scenes/prizes/prize_card.tscn").instantiate()
		prize_card.prize = _generate_prize()
		prize_card.pressed.connect(_on_prize_card_selected.bind(prize_card))
		$HBoxContainer.add_child(prize_card)

func close():
	for child in $HBoxContainer.get_children():
		child.queue_free()

func _on_prize_card_selected(prize_card):
	var prize = prize_card.prize
	if prize.type == Prize.PrizeType.ADD_MONEY:
		was_completed.emit()
	elif prize.type == Prize.PrizeType.ADD_RUNE:
		was_completed_with_rune.emit(prize.rune)

func _generate_prize():
	if randf() < 0.5:
		return _create_money_prize()
	else:
		return _create_rune_prize()
		
func _create_money_prize() -> Prize:
	var prize = Prize.new()
	prize.amount = randi_range(1, 5)
	prize.type = Prize.PrizeType.ADD_MONEY
	prize.title = "ADD MONEY"
	prize.image_path = "res://icon.svg"
	prize.description = str("Adds $", prize.amount, " to the bank")
	return prize

func _create_rune_prize() -> Prize:
	var prize = Prize.new()
	prize.type = Prize.PrizeType.ADD_RUNE
	var rune: Rune = RUNES.pick_random().instantiate()
	prize.title = "ADD RUNE"
	prize.image_resource = rune.icon
	prize.description = str("Adds ", rune.display_name, " rune to the deck")
	prize.rune = rune
	return prize

class Prize:
	var title: String
	var image_path: String
	var image_resource: Texture2D
	var description: String
	var type: PrizeType

	enum PrizeType {
		ADD_RUNE,
		ADD_MONEY
	}
	
	#  For ADD_MONEY type
	var amount: int
	
	#  For ADD_RUNE type
	var rune: Rune
