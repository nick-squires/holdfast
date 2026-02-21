# PathfindingSystem.gd — A* on hex grid, used by all unit movement
extends Node

func find_path(from: Vector2i, to: Vector2i) -> Array[Vector2i]:
	# A* pathfinding on hex grid using HexGrid utilities
	var open_set: Array[Vector2i] = [from]
	var came_from: Dictionary = {}
	var g_score: Dictionary = { from: 0 }
	var f_score: Dictionary = { from: HexGrid.hex_distance(from, to) }

	while not open_set.is_empty():
		# Find node in open_set with lowest f_score
		var current: Vector2i = open_set[0]
		var best_f: int = f_score.get(current, 999999)
		for node in open_set:
			var f: int = f_score.get(node, 999999)
			if f < best_f:
				current = node
				best_f = f

		if current == to:
			return _reconstruct_path(came_from, current)

		open_set.erase(current)

		for neighbor in HexGrid.hex_neighbors(current):
			if not HexGrid.hex_in_bounds(neighbor, MapGenerator.MAP_COLS, MapGenerator.MAP_ROWS):
				continue

			var tile_data: Dictionary = GameState.tile_data.get(neighbor, {})
			var terrain: Dictionary = DataLoader.terrain.get(tile_data.get("type", ""), {})
			var move_cost: int = terrain.get("movement_cost", -1)
			if move_cost < 0:
				continue  # Impassable

			var tentative_g: int = g_score.get(current, 999999) + move_cost
			if tentative_g < g_score.get(neighbor, 999999):
				came_from[neighbor] = current
				g_score[neighbor] = tentative_g
				f_score[neighbor] = tentative_g + HexGrid.hex_distance(neighbor, to)
				if neighbor not in open_set:
					open_set.append(neighbor)

	return []  # No path found


func _reconstruct_path(came_from: Dictionary, current: Vector2i) -> Array[Vector2i]:
	var path: Array[Vector2i] = [current]
	while current in came_from:
		current = came_from[current]
		path.insert(0, current)
	return path
