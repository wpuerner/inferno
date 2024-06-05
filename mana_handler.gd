extends Node

@onready var mana_bar: ProgressBar = get_node("/root/Main").find_child("ManaBar")

var mana_gain_rate: int  #mana per second

var mana: int:
	set(value):
		mana = value
		mana_bar.value = value
var timer: Timer

func _ready():
	_reset()
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = false
	timer.timeout.connect(_gain_mana)
	timer.start(1)

func _gain_mana():
	increase_mana(mana_gain_rate)

func increase_mana(value: int):
	mana = mana + value
	clamp(mana, 0, 1000)

func decrease_mana(value: int):
	mana -= value
	if mana < 0:
		push_warning("Please check has_enough_mana() before calling decrease mana")
	clamp(mana, 0, 1000)

func has_enough_mana(value: int) -> bool:
	return mana >= value

func _reset():
	mana = 1000
	mana_gain_rate = 10
