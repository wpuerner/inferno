extends Node

@onready var parent: CharacterBody2D = get_parent()
@onready var timer: Timer = $Timer
@onready var mana_handler: Node = get_node_or_null("/root/Main/ManaHandler")
@onready var event_bus: Node = get_node("/root/EventBus")

var warping: bool = false
var direction: Vector2
var speed: float = 1000
var mana_cost: int = 100
var default_collision_layer: int
var initial_velocity: Vector2

func _ready():
	default_collision_layer = parent.collision_layer
	event_bus.level_loaded.connect(func(): queue_free())

func _input(event: InputEvent):
	if !event.is_action_pressed("secondary"): return
	if mana_handler:
		if !mana_handler.has_enough_mana(mana_cost): return
		mana_handler.decrease_mana(mana_cost)
		
	initial_velocity = parent.velocity
	
	var effect = preload("res://scenes/parts/warp_utility/warp_effect.tscn").instantiate()
	effect.global_position = parent.global_position
	parent.add_sibling(effect)
	
	parent.modulate = Color.TRANSPARENT
	parent.collision_layer = 0
	parent.set_physics_process(false)
	
	direction = Vector2(Input.get_axis("move_left", "move_right"), Input.get_axis("move_up", "move_down")).normalized()
	parent.velocity = direction * speed
	
	warping = true
	timer.start()
	
func _physics_process(_delta):
	if !warping: return
	parent.move_and_slide()

func _on_timer_timeout():
	warping = false
	parent.modulate = Color.WHITE
	parent.collision_layer = default_collision_layer
	parent.velocity = initial_velocity
	parent.set_physics_process(true)
	
