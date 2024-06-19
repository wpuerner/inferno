extends ProgressBar

@onready var event_bus: Node = get_node("/root/EventBus")

func _ready():
	event_bus.player_health_updated.connect(func(amount): value = amount)
