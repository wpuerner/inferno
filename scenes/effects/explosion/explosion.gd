extends Area2D

func _ready():
	$CPUParticles2D.emitting = true

func _on_body_entered(body):
	if "health_attribute" in body:
		body.health_attribute.apply_damage(50)

func _on_timer_timeout():
	queue_free()
