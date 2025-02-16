extends Object

enum RuneType {
	HEALTH_UP,
	FIRE_RATE_UP,
	NUMBER_PROJECTILES_UP,
	CHAIN_LIGHTNING,
}

const RUNE_RESOURCE_MAP = {
	RuneType.HEALTH_UP: preload("res://scenes/runes/health_up/health_up.tscn"),
	RuneType.FIRE_RATE_UP: preload("res://scenes/runes/fire_rate_up/fire_rate_up.tscn"),
	RuneType.NUMBER_PROJECTILES_UP: preload("res://scenes/runes/number_projectiles_up/number_projectiles_up.tscn"),
	RuneType.CHAIN_LIGHTNING: preload("res://scenes/runes/chain_lightning/chain_lightning.tscn")
}

const RUNE_RARITY_MAP = {
	RuneType.HEALTH_UP: Rune.Rarity.COMMON,
	RuneType.FIRE_RATE_UP: Rune.Rarity.COMMON,
	RuneType.NUMBER_PROJECTILES_UP: Rune.Rarity.UNCOMMON,
	RuneType.CHAIN_LIGHTNING: Rune.Rarity.UNCOMMON,
}

func get_rune_resource(type: RuneType):
	return RUNE_RESOURCE_MAP.get(type)
	
func get_rune_by_rarity() -> RuneType:
	var index: int = 0
	var weight_map = {}
	for rune_type in RUNE_RARITY_MAP.keys():
		var weight: int = 0
		match RUNE_RARITY_MAP[rune_type]:
			Rune.Rarity.COMMON:
				weight = 4
			Rune.Rarity.UNCOMMON:
				weight = 2
			Rune.Rarity.RARE:
				weight = 1
			_:
				push_error("An unknown rarity was encountered when creating rarity weights for rune type ", rune_type)
		while weight > 0:
			weight_map[index] = rune_type
			index += 1
			weight -= 1
	return weight_map[randi_range(0, index - 1)]

enum AttributeType {
	BULLET_SPAWN,
	FIRE_RATE_MULTIPLIER,
	NUMBER_PROJECTILES,
	PLAYER_HEALTH
}

var attribute_resource_map = {
	AttributeType.BULLET_SPAWN: preload("res://scenes/attributes/bullet_spawn/bullet_spawn_attribute.tres"),
	AttributeType.FIRE_RATE_MULTIPLIER: preload("res://scenes/attributes/fire_rate_multiplier/fire_rate_multiplier_attribute.tres"),
	AttributeType.NUMBER_PROJECTILES: preload("res://scenes/attributes/number_projectiles_attribute/number_projectiles_attribute.tres"),
	AttributeType.PLAYER_HEALTH: preload("res://scenes/attributes/player_health/player_health_attribute.tres"),
}

func get_all_attribute_resources():
	return attribute_resource_map.values()
