extends Camera2D

@export var player: Node2D
var follow_speed = 10

const INNER_BACKGROUND_PAN_FACTOR: float = 0.5
const OUTER_BACKGROUND_PAN_FACTOR: float = 0.2

func _ready():
	$Background.region_rect.size = get_viewport_rect().size
	$Background2.region_rect.size = get_viewport_rect().size

func _process(delta: float):
	if !is_instance_valid(player): return
	global_position = global_position.lerp(player.global_position, delta * follow_speed)
	
	$Background.region_rect.position = global_position * INNER_BACKGROUND_PAN_FACTOR
	$Background2.region_rect.position = global_position * OUTER_BACKGROUND_PAN_FACTOR
