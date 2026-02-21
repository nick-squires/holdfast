# DebugOverlay.gd — Debug text display for HexMap testing
extends Label

func _ready() -> void:
	SignalBus.tile_clicked.connect(_on_tile_clicked)
	SignalBus.tile_hovered.connect(_on_tile_hovered)
	# Position the label in the top-left corner
	add_theme_font_size_override("font_size", 16)


func _on_tile_clicked(hex_coord: Vector2i) -> void:
	var tile_type: String = GameState.tile_data.get(hex_coord, {}).get("type", "unknown")
	var neighbors: Array[Vector2i] = HexGrid.hex_neighbors(hex_coord)
	var valid_neighbors: Array[Vector2i] = []
	for n in neighbors:
		if HexGrid.hex_in_bounds(n, MapGenerator.MAP_COLS, MapGenerator.MAP_ROWS):
			valid_neighbors.append(n)

	text = "CLICKED: (%d, %d) type=%s\nNeighbors: %s" % [
		hex_coord.x, hex_coord.y, tile_type, str(valid_neighbors)
	]
	print("Tile clicked: (%d, %d) type=%s" % [hex_coord.x, hex_coord.y, tile_type])
	print("  Neighbors: %s" % str(valid_neighbors))


func _on_tile_hovered(hex_coord: Vector2i) -> void:
	var tile_type: String = GameState.tile_data.get(hex_coord, {}).get("type", "unknown")
	text = "Hover: (%d, %d) type=%s" % [hex_coord.x, hex_coord.y, tile_type]
