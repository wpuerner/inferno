extends Node2D

func _ready():
	for child in find_children("FlockingMob*"):
		child.target = $Target
	
func _input(event: InputEvent):
	if !event.is_action_pressed("primary_fire"): return
	var chain_lightning = preload("res://scenes/effects/chain_lightning/chain_lightning.tscn").instantiate()
	chain_lightning.global_position = $Target.global_position
	add_child(chain_lightning)
	
func _physics_process(_delta):
	$Target.global_position = get_global_mouse_position()
	queue_redraw()
	
func _draw():
	draw_circle($Target.global_position, 4, Color.GREEN)
