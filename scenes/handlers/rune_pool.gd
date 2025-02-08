extends Node

@onready var debug_overlay = get_node("/root/DebugOverlay")

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
	for i in range(0, 5):
		if deck.size() == 0:
			_shuffle_deck()
		# If the deck is still empty after reshuffling, just return what is already in the hand.
		# Can happen if there are fewer cards in the deck than go to a hand.
		if deck.size() == 0:
			return hand
		hand.append(deck.pop_front())
	debug_overlay.print("Deck size", deck.size())
	debug_overlay.print("Discard size", discard.size())
	return hand
	
func discard_hand():
	while hand.size() > 0:
		discard.append(hand.pop_front())
	debug_overlay.print("Hand size", hand.size())
	debug_overlay.print("Discard size", discard.size())
	
func add_rune(rune: Rune):
	add_child(rune)
	discard.append(rune)
	debug_overlay.print("Discard size", discard.size())

func _ready():
	for child in get_children().filter(func(child): return child is Rune):
		deck.append(child)
	_shuffle_deck()
	
func _shuffle_deck():
	while discard.size() > 0:
		deck.append(discard.pop_front())
	deck.shuffle()
	debug_overlay.print("Deck size", deck.size())
	debug_overlay.print("Discard size", discard.size())
