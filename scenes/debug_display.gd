extends Label

func _ready():
	get_node("/root/DebugOverlay").bind_debug_label(self)
