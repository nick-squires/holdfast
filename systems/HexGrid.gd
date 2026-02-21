# HexGrid.gd — Pure hex math, no nodes, no dependencies
# Uses "odd-r" offset layout (odd rows shifted right)
class_name HexGrid

# Neighbor directions for odd-r offset coordinates
# Even row neighbors
const EVEN_ROW_DIRS: Array[Vector2i] = [
	Vector2i(1, 0), Vector2i(0, -1), Vector2i(-1, -1),
	Vector2i(-1, 0), Vector2i(-1, 1), Vector2i(0, 1),
]
# Odd row neighbors
const ODD_ROW_DIRS: Array[Vector2i] = [
	Vector2i(1, 0), Vector2i(1, -1), Vector2i(0, -1),
	Vector2i(-1, 0), Vector2i(0, 1), Vector2i(1, 1),
]

# Hex tile dimensions — flat-top hex
# outer_radius = distance from center to vertex
# inner_radius = distance from center to edge midpoint = outer * sqrt(3)/2
const TILE_OUTER_RADIUS: float = 1.0
const TILE_INNER_RADIUS: float = 0.866025  # sqrt(3)/2


static func offset_to_cube(hex: Vector2i) -> Vector3i:
	var col: int = hex.x
	var row: int = hex.y
	var x: int = col - (row - (row & 1)) / 2
	var z: int = row
	var y: int = -x - z
	return Vector3i(x, y, z)


static func cube_to_offset(cube: Vector3i) -> Vector2i:
	var col: int = cube.x + (cube.z - (cube.z & 1)) / 2
	var row: int = cube.z
	return Vector2i(col, row)


static func hex_distance(a: Vector2i, b: Vector2i) -> int:
	var ac := offset_to_cube(a)
	var bc := offset_to_cube(b)
	return (absi(ac.x - bc.x) + absi(ac.y - bc.y) + absi(ac.z - bc.z)) / 2


static func hex_neighbors(hex: Vector2i) -> Array[Vector2i]:
	var dirs: Array[Vector2i] = ODD_ROW_DIRS if (hex.y & 1) else EVEN_ROW_DIRS
	var result: Array[Vector2i] = []
	for d in dirs:
		result.append(hex + d)
	return result


static func hex_ring(center: Vector2i, radius: int) -> Array[Vector2i]:
	if radius == 0:
		return [center]
	var results: Array[Vector2i] = []
	# Start at cube direction 4 (bottom-left), walk around the ring
	var cube_center := offset_to_cube(center)
	# Direction vectors in cube coordinates
	var cube_dirs: Array[Vector3i] = [
		Vector3i(1, -1, 0), Vector3i(0, -1, 1), Vector3i(-1, 0, 1),
		Vector3i(-1, 1, 0), Vector3i(0, 1, -1), Vector3i(1, 0, -1),
	]
	# Start position: move radius steps in direction 4
	var cube_pos: Vector3i = cube_center + cube_dirs[4] * radius
	for i in range(6):
		for _j in range(radius):
			results.append(cube_to_offset(cube_pos))
			cube_pos += cube_dirs[i]
	return results


static func hex_to_world(hex: Vector2i, tile_size: float = TILE_OUTER_RADIUS) -> Vector3:
	# Odd-r offset to world position (pointy-top style for odd-r)
	var col: float = hex.x
	var row: float = hex.y
	var x: float = tile_size * sqrt(3.0) * (col + 0.5 * (int(row) & 1))
	var z: float = tile_size * 1.5 * row
	return Vector3(x, 0.0, z)


static func world_to_hex(world: Vector3, tile_size: float = TILE_OUTER_RADIUS) -> Vector2i:
	# World position to nearest odd-r offset hex
	var row_approx: float = world.z / (tile_size * 1.5)
	var row: int = roundi(row_approx)
	var col_approx: float = world.x / (tile_size * sqrt(3.0)) - 0.5 * (row & 1)
	var col: int = roundi(col_approx)
	# Check the 3 closest candidates and pick the nearest
	var best := Vector2i(col, row)
	var best_dist: float = hex_to_world(best, tile_size).distance_squared_to(world)
	for neighbor in hex_neighbors(best):
		var d: float = hex_to_world(neighbor, tile_size).distance_squared_to(world)
		if d < best_dist:
			best = neighbor
			best_dist = d
	return best


static func hex_in_bounds(hex: Vector2i, cols: int, rows: int) -> bool:
	return hex.x >= 0 and hex.x < cols and hex.y >= 0 and hex.y < rows
