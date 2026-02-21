# HexMap.gd — The game world; owns hex tile instances
extends Node3D

@onready var map_generator: MapGenerator = $MapGenerator

var tiles: Dictionary = {}  # { Vector2i: HexTile node }
var tile_data: Dictionary = {}  # { Vector2i: { type, building, units } }

const HexTileScene := preload("res://world/HexTile.tscn")


func _ready() -> void:
	generate_map()


func generate_map() -> void:
	# Clear existing tiles
	for coord in tiles:
		tiles[coord].queue_free()
	tiles.clear()

	# Generate tile data from noise
	tile_data = map_generator.generate()
	GameState.tile_data = tile_data

	# Instance tile scenes
	for coord in tile_data:
		var data: Dictionary = tile_data[coord]
		var tile: Node3D = HexTileScene.instantiate()
		var world_pos: Vector3 = HexGrid.hex_to_world(coord)
		tile.position = world_pos
		add_child(tile)
		tile.setup(coord, data["type"])
		tiles[coord] = tile

	# Calculate and set map bounds
	_update_map_bounds()


func get_tile(coord: Vector2i) -> Node3D:
	return tiles.get(coord, null)


func get_tile_type(coord: Vector2i) -> String:
	var data: Dictionary = tile_data.get(coord, {})
	return data.get("type", "")


func has_adjacent_terrain(coord: Vector2i, terrain_type: String) -> bool:
	for neighbor in HexGrid.hex_neighbors(coord):
		if get_tile_type(neighbor) == terrain_type:
			return true
	return false


func has_nearby_building(coord: Vector2i, building_id: String, max_distance: int) -> bool:
	# Check all tiles within max_distance for a specific building type
	for radius in range(1, max_distance + 1):
		for ring_coord in HexGrid.hex_ring(coord, radius):
			var data: Dictionary = tile_data.get(ring_coord, {})
			if data.get("building", null) == building_id:
				return true
	return false


func _update_map_bounds() -> void:
	if tiles.is_empty():
		return
	var min_pos := Vector3(INF, 0, INF)
	var max_pos := Vector3(-INF, 0, -INF)
	for coord in tiles:
		var pos: Vector3 = tiles[coord].position
		min_pos.x = minf(min_pos.x, pos.x)
		min_pos.z = minf(min_pos.z, pos.z)
		max_pos.x = maxf(max_pos.x, pos.x)
		max_pos.z = maxf(max_pos.z, pos.z)
	# Add some padding
	min_pos -= Vector3(3, 0, 3)
	max_pos += Vector3(3, 0, 3)
	# Notify camera if present
	var camera := get_viewport().get_camera_3d()
	if camera and camera.has_method("set_map_bounds"):
		camera.set_map_bounds(min_pos, max_pos)
