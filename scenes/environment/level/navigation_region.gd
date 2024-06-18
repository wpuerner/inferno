extends NavigationRegion2D

func generate(bounds: Rect2):
	navigation_polygon.clear_outlines()
	navigation_polygon.clear()
	
	var points: PackedVector2Array = []
	points.append(Vector2(bounds.position.x, bounds.position.y))
	points.append(Vector2(bounds.end.x, bounds.position.y))
	points.append(Vector2(bounds.end.x, bounds.end.y))
	points.append(Vector2(bounds.position.x, bounds.end.y))
	navigation_polygon.add_outline(points)
	
	bake_navigation_polygon(true)
