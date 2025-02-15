extends Rune

var bullet_spawn_attribute: ArrayAttribute = preload("res://scenes/attributes/bullet_spawn/bullet_spawn_attribute.tres")

func activate():
	bullet_spawn_attribute.add(preload("res://scenes/effects/chain_lightning/chain_lightning.tscn"))
