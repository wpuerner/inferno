extends Node2D

@onready var hand: Node2D = find_child("Hand")

var num_spawns: int = 5

func _ready():
	$HandCanvasLayer.find_child("Hand").position = get_viewport_rect().size / 2
	$HandCanvasLayer.visible = true
	hand.open_with_runes($RunePool.get_hand())

func _on_play_button_pressed():
	$HandCanvasLayer.visible = false
	$EnemySpawnTimer.start(randf_range(1.0, 5.0))

func _on_enemy_spawn_timer_timeout():
	var num_enemies: int = randi_range(5, 15)
	var spawn_position: Vector2 = Vector2(randi_range(-500, 500), randi_range(-500, 500))
	while num_enemies > 0:
		var enemy = preload("res://scenes/mobs/flocking_mob/flocking_mob.tscn").instantiate()
		enemy.global_position = spawn_position + Vector2(randi_range(-50, 50), randi_range(-50, 50))
		enemy.target = $Player
		add_child(enemy)
		num_enemies -= 1
	num_spawns -= 1
	if num_spawns > 0:
		$EnemySpawnTimer.start(randf_range(1.0, 5.0))
