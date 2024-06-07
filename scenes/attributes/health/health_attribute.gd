class_name HealthAttribute extends Resource

@export var health: int = 100:
	set(value):
		health = value
		if health <= 0:
			get_local_scene().queue_free()
			
func apply_damage(amount:int):
	health -= amount
