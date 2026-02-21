# BuildingPlacer.gd — Validates + instances buildings onto tiles
extends Node

func can_place(building_id: String, hex_coord: Vector2i, hex_map: Node) -> bool:
	var data: Dictionary = DataLoader.get_building(building_id)
	if data.is_empty():
		return false

	# Check tile exists and is buildable
	var tile_data: Dictionary = GameState.tile_data.get(hex_coord, {})
	if tile_data.is_empty():
		return false
	var terrain_data: Dictionary = DataLoader.terrain.get(tile_data.get("type", ""), {})
	if not terrain_data.get("buildable", false):
		return false

	# Check no existing building
	if tile_data.get("building", null) != null:
		return false

	# Check cost
	if not ResourceManager.can_afford(data.get("cost", {})):
		return false

	# Check terrain adjacency requirement
	var req_terrain: Variant = data.get("requires_adjacent_terrain", null)
	if req_terrain is String and req_terrain != "":
		if not hex_map.has_adjacent_terrain(hex_coord, req_terrain):
			return false

	# Check nearby building requirement
	var req_building: Variant = data.get("requires_nearby_building", null)
	if req_building is Dictionary:
		var req_id: String = req_building.get("building", "")
		var max_dist: int = req_building.get("max_distance", 1)
		if not hex_map.has_nearby_building(hex_coord, req_id, max_dist):
			return false

	# Check center tile only
	if data.get("center_tile_only", false):
		var center := Vector2i(MapGenerator.MAP_COLS / 2, MapGenerator.MAP_ROWS / 2)
		if hex_coord != center:
			return false

	return true


func place(building_id: String, hex_coord: Vector2i, hex_map: Node) -> bool:
	if not can_place(building_id, hex_coord, hex_map):
		return false

	var data: Dictionary = DataLoader.get_building(building_id)

	# Spend resources
	if not ResourceManager.spend_cost(data.get("cost", {})):
		return false

	# Mark tile as occupied
	GameState.tile_data[hex_coord]["building"] = building_id

	# Clear decorations on the tile
	var tile: Node3D = hex_map.get_tile(hex_coord)
	if tile and tile.has_method("clear_decorations"):
		tile.clear_decorations()

	SignalBus.building_placed.emit(building_id, hex_coord)
	return true
