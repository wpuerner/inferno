extends Node2D

@export var player_health_attribute: Attribute

@onready var hand: Node2D = find_child("Hand")
@onready var debug_overlay = get_node("/root/DebugOverlay")
@onready var health_bar: ProgressBar = $GameplayOverlayCanvasLayer.find_child("HealthBar")

var num_spawns: int = 2:
	set(value):
		num_spawns = value
		debug_overlay.print("Number spawns remaining", num_spawns)
var active_enemies: Array[Node2D] = []

func _ready():
	player_health_attribute.was_changed.connect(_on_player_health_attribute_was_changed)
	$HandCanvasLayer.find_child("Hand").position = get_viewport_rect().size / 2
	$AttributeHandler.reset()
	_open_hand()

func _on_play_button_pressed():
	hand.activate()
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
	$LevelCompleteCanvasLayer.visible = true
	$LevelCompleteCanvasLayer/PrizeOverlay.open()

func _open_hand():
	$HandCanvasLayer.visible = true
	hand.open_with_runes($RunePool.get_hand())

func _on_player_health_attribute_was_changed(new_amount):
	health_bar.value = new_amount

func _on_new_run_button_pressed():
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_player_was_killed():
	$GameplayMenuCanvasLayer.find_child("GameOverMenu").visible = true

func _on_prize_overlay_was_completed():
	$LevelCompleteCanvasLayer/PrizeOverlay.close()
	$LevelCompleteCanvasLayer.visible = false
	$AttributeHandler.reset()
	_open_hand()

func _on_prize_overlay_was_completed_with_rune(rune: Rune):
	$RunePool.add_rune(rune)
	$LevelCompleteCanvasLayer/PrizeOverlay.close()
	$LevelCompleteCanvasLayer.visible = false
	$AttributeHandler.reset()
	_open_hand()
