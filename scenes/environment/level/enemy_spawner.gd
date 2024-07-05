extends Node

@onready var rune_pool: Node = get_node("/root/RunePool")

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var enemy_data: Array = [
	{
		"name": "skull",
		"path": "res://scenes/mobs/skull/skull.tscn",
		"energy": 10
	}
]

func spawn(spawn_positions: PackedVector2Array, energy: int):
	rng.randomize()
	while energy >= 0:
		var enemy_index = rng.randi_range(0, enemy_data.size() - 1)
		var data = enemy_data[enemy_index]
		var enemy = load(data["path"]).instantiate()
		add_child(enemy)
		var position_index = rng.randi_range(0, spawn_positions.size() - 1)
		enemy.global_position = spawn_positions[position_index]
		spawn_positions.remove_at(position_index)
		energy -= data["energy"]

func _on_child_exiting_tree(node):
	if get_child_count() <= 1:
		var overworld_rune = preload("res://scenes/runes/overworld_rune/overworld_rune.tscn").instantiate()
		overworld_rune.rune = rune_pool.get_random_rune()
		overworld_rune.global_position = node.global_position
		add_sibling.call_deferred(overworld_rune)
