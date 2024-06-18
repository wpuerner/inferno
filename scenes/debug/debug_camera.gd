extends Camera2D

func _ready():
	push_error("Don't leave Debug camera while running!")

func _process(delta: float):
	var horiz: float = Input.get_axis("move_left", "move_right")
	var vert: float = Input.get_axis("move_up", "move_down")
	global_position += delta * Vector2(horiz, vert) * 5000
