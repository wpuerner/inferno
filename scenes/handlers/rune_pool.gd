extends Node

var rune_scene_paths: Array[String] = [
	"res://scenes/runes/scatter_shot/scatter_shot.tscn",
	"res://scenes/runes/rapid_fire/rapid_fire.tscn",
	"res://scenes/runes/explosive/explosive.tscn",
	"res://scenes/runes/worms/worms.tscn",
	"res://scenes/runes/warp/warp.tscn"
]

var hand: Array[Rune]
var deck: Array[Rune]
var discard: Array[Rune]

func get_hand() -> Array[Rune]:
	var hand
	for i in range(0, 5):
		if deck.size() == 0:
			deck.append(discard.duplicate(true))
			discard.clear()
			_shuffle_deck()
		# If the deck is still empty after reshuffling, just return what is already in the hand.
		# Can happen if there are fewer cards in the deck than go to a hand.
		if deck.size() == 0:
			return hand
		hand.append(deck.pop_front())
	return hand

func add_rune(rune: Rune):
	add_child(rune)
	discard.append(rune)

func _ready():
	deck = get_children().filter(func(child): return child is Rune)
	_shuffle_deck()
	
func _shuffle_deck():
	deck.shuffle()
