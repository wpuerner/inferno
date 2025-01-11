extends CharacterBody2D

@onready var event_bus: Node = get_node("/root/EventBus")
@onready var health_attribute: Node = $PlayerHealth

const max_speed: float = 300
const acceleration: float = 1800
const deceleration: float = 2200

func _ready():
	event_bus.pre_level_started.connect(func(): set_physics_process(false))
	event_bus.player_picked_up_room_rune.connect(func(_rune): set_physics_process(false))
	event_bus.gameplay_started.connect(func(): set_physics_process(true))

func _physics_process(delta: float):
	var direction_x: float = Input.get_axis("move_left", "move_right")
	var direction_y: float = Input.get_axis("move_up", "move_down")
	var direction: Vector2 = Vector2(direction_x, direction_y).normalized()
	
	print_debug(direction)
	
	if direction.length() > 0:
		velocity = velocity.move_toward(direction * max_speed, delta * acceleration)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * deceleration)

	move_and_slide()
