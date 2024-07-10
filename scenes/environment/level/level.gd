extends Node2D

@onready var tile_map: TileMap = $TileMap
@onready var enemy_spawner: Node = $EnemySpawner

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var starting_position: Vector2i
var grid: Array = []
var grid_bounds: Rect2i
var spawn_positions: PackedVector2Array = []

func generate(level_number: int) -> Vector2:
	rng.randomize()
	_generate_grid()
	_paint_floor()
	_place_walls()
	_set_tile_map()
	_generate_navigation_region()
	_generate_spawn_positions()
	enemy_spawner.spawn(spawn_positions, level_number * 50)
	return tile_map.to_global(tile_map.map_to_local(starting_position))
	
func _generate_grid():
	var grid_side_length: int = 50
	grid.resize(grid_side_length)
	for i in grid.size():
		grid[i] = PackedInt32Array()
		grid[i].resize(grid_side_length)
		grid[i].fill(0)

func _paint_floor():
	var length_x: int = grid.size()
	var length_y: int = grid[0].size()
	
	starting_position = Vector2i(grid.size() / 2, grid[0].size() / 2)
	grid_bounds = Rect2i(starting_position, Vector2i.ZERO)
	var walker: Vector2i = starting_position
	grid[walker.x][walker.y] = 1
	
	var iterations = 200
	var itr = 0
	while itr < iterations:
		var direction: Vector2i = _get_random_direction()
		if (walker.x + direction.x > 0 and 
			walker.x + direction.x < length_x - 1 and
			walker.y + direction.y > 0 and
			walker.y + direction.y < length_y - 1):
			walker += direction
			grid[walker.x][walker.y] = 1
			itr += 1

func _get_random_direction() -> Vector2i:
	var directions = [[-1, 0], [1, 0], [0, 1], [0, -1]]
	var direction = directions[rng.randi() % 4]
	return Vector2i(direction[0], direction[1])

func _place_walls():
	for x in grid.size() - 1:
		for y in grid[x].size() - 1:
			if grid[x][y] == 0 and _is_adjacent_to_floor(x, y):
				grid[x][y] = 2
				if x < grid_bounds.position.x:
					grid_bounds.position.x = x
				if x > grid_bounds.end.x:
					grid_bounds.end.x = x
				if y < grid_bounds.position.y:
					grid_bounds.position.y = y
				if y > grid_bounds.end.y:
					grid_bounds.end.y = y

func _is_adjacent_to_floor(x: int, y: int):
	return grid[x+1][y] == 1 or grid[x-1][y] == 1 or grid[x][y+1] == 1 or grid[x][y-1] == 1 or grid[x+1][y+1] == 1 or grid[x-1][y+1] == 1 or grid[x+1][y-1] == 1 or grid[x-1][y-1] == 1

func _set_tile_map():
	tile_map.clear()
	for x in grid.size() - 1:
		for y in grid[x].size():
			if grid[x][y] != 0: tile_map.set_cell(1, Vector2i(x, y), 1, Vector2i(0, 0))
			if grid[x][y] == 2 or grid[x][y] == 0: tile_map.set_cells_terrain_connect(0, [Vector2i(x, y)], 0, 0)

func _generate_navigation_region():
	var bounds: Rect2 = Rect2(tile_map.to_global(tile_map.map_to_local(grid_bounds.position)), tile_map.to_global(tile_map.map_to_local(grid_bounds.size)))
	$NavigationRegion2D.generate(bounds)

func _generate_spawn_positions():
	spawn_positions.clear()
	for x in grid.size():
		for y in grid[x].size():
			if grid[x][y] == 1 and Vector2i(x - starting_position.x, y - starting_position.y).abs().length() > 5:
				spawn_positions.append(tile_map.to_global(tile_map.map_to_local(Vector2i(x, y))))
