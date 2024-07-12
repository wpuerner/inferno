extends Rune

func activate():
	get_node("/root/Main").find_child("Player").add_child(preload("res://scenes/parts/warp_utility/warp_utility.tscn").instantiate())
