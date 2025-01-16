extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var event_bus: Node = get_node("/root/EventBus")

const speed: float = 200
var player: Node2D
var is_enabled: bool = false

func _ready():
	event_bus.gameplay_started.connect(func(): is_enabled = true)
	set_physics_process(false)
	
func _physics_process(_delta: float):
	navigation_agent_2d.target_position = player.global_position
	velocity = global_position.direction_to(navigation_agent_2d.get_next_path_position()) * speed
	move_and_slide()

func _on_entity_health_health_was_depleated():
	event_bus.kill_mob(self)
	queue_free()
