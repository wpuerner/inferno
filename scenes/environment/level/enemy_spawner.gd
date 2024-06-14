extends Node

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var enemy_data: Array = [
	{
		"name": "skull",
		"path": "res://scenes/mobs/skull/skull.tscn",
		"energy": 10
	}
]

var energy: int

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
