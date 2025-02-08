extends Node2D

@onready var hand: Node2D = find_child("Hand")
@onready var debug_overlay = get_node("/root/DebugOverlay")

var num_spawns: int = 2:
	set(value):
		num_spawns = value
		debug_overlay.print("Number spawns remaining", num_spawns)
var active_enemies: Array[Node2D] = []

func _ready():
	$HandCanvasLayer.find_child("Hand").position = get_viewport_rect().size / 2
	_open_hand()

func _on_play_button_pressed():
	hand.close()
	await hand.was_closed
	$HandCanvasLayer.visible = false
	$RunePool.discard_hand()
	num_spawns = 2
	$EnemySpawnTimer.start(randf_range(1.0, 5.0))
	$Player.process_mode = Node.PROCESS_MODE_INHERIT

func _on_enemy_spawn_timer_timeout():
	var num_enemies: int = randi_range(5, 6)
	var spawn_position: Vector2 = Vector2(randi_range(-500, 500), randi_range(-500, 500))
	while num_enemies > 0:
		var enemy = preload("res://scenes/mobs/flocking_mob/flocking_mob.tscn").instantiate()
		active_enemies.append(enemy)
		debug_overlay.print("Number of active enemies", active_enemies.size())
		enemy.tree_exiting.connect(_handle_destroyed_enemy.bind(enemy))
		enemy.global_position = spawn_position + Vector2(randi_range(-50, 50), randi_range(-50, 50))
		enemy.target = $Player
		add_child(enemy)
		num_enemies -= 1
	num_spawns -= 1
	if num_spawns > 0:
		$EnemySpawnTimer.start(randf_range(1.0, 5.0))

func _handle_destroyed_enemy(enemy: Node2D):
	active_enemies.erase(enemy)
	debug_overlay.print("Number of active enemies", active_enemies.size())
	if num_spawns == 0 and active_enemies.size() == 0:
		_finish_level()

func _finish_level():
	$Player.process_mode = Node.PROCESS_MODE_DISABLED
	_open_hand()

func _open_hand():
	$HandCanvasLayer.visible = true
	hand.open_with_runes($RunePool.get_hand())
