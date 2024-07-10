extends Node

@onready var rune_pool: Node = get_node("/root/RunePool")
@onready var event_bus: Node = get_node("/root/EventBus")

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var enemy_data: Array = [
	{
		"name": "skull",
		"path": "res://scenes/mobs/skull/skull.tscn",
		"energy": 10
	},
	{
		"name": "mantle",
		"path": "res://scenes/mobs/mantle/mantle.tscn",
		"energy": 10
	}
]
var mobs: Array[Node2D]

func spawn(spawn_positions: PackedVector2Array, energy: int):
	rng.randomize()
	while energy >= 0:
		var enemy_index = rng.randi_range(0, enemy_data.size() - 1)
		var data = enemy_data[enemy_index]
		var enemy = load(data["path"]).instantiate()
		mobs.append(enemy)
		add_child(enemy)
		var position_index = rng.randi_range(0, spawn_positions.size() - 1)
		enemy.global_position = spawn_positions[position_index]
		spawn_positions.remove_at(position_index)
		energy -= data["energy"]
		
func _ready():
	event_bus.level_loaded.connect(_remove_all_children)
	event_bus.mob_was_killed.connect(_handle_mob_was_killed)

func _handle_mob_was_killed(mob: Node2D):
	mobs.erase(mob)
	if mobs.size() <= 0:
		var overworld_rune = preload("res://scenes/runes/overworld_rune/overworld_rune.tscn").instantiate()
		overworld_rune.rune = rune_pool.get_random_rune()
		overworld_rune.global_position = mob.global_position
		add_sibling.call_deferred(overworld_rune)

func _remove_all_children():
	for child in get_children():
		child.queue_free()
