# MapGenerator.gd — Procedural hex layout from noise
extends Node

const MAP_COLS: int = 15
const MAP_ROWS: int = 12

@export var noise_seed: int = 0
@export var noise_frequency: float = 0.08

var noise: FastNoiseLite


func _ready() -> void:
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	noise.seed = noise_seed
	noise.frequency = noise_frequency


func generate() -> Dictionary:
	# Returns { Vector2i: { "type": String, "building": null, "units": [] } }
	var tile_data: Dictionary = {}

	for row in range(MAP_ROWS):
		for col in range(MAP_COLS):
			var hex := Vector2i(col, row)
			var noise_val: float = noise.get_noise_2d(float(col), float(row))
			var tile_type: String = _noise_to_type(noise_val, hex)
			tile_data[hex] = {
				"type": tile_type,
				"building": null,
				"units": [],
			}

	# Guarantee center tile is grass (for Great Hall placement)
	var center := Vector2i(MAP_COLS / 2, MAP_ROWS / 2)
	tile_data[center]["type"] = "grass"
	# Also ensure center neighbors are buildable (not water)
	for neighbor in HexGrid.hex_neighbors(center):
		if HexGrid.hex_in_bounds(neighbor, MAP_COLS, MAP_ROWS):
			if tile_data[neighbor]["type"] == "water":
				tile_data[neighbor]["type"] = "grass"

	return tile_data


func _noise_to_type(value: float, hex: Vector2i) -> String:
	# FastNoiseLite simplex output is roughly [-1, 1] with gaussian-like distribution
	# Thresholds tuned for target: ~60% grass, ~20% forest, ~10% mountain, ~10% water
	if value > 0.0:
		return "grass"
	elif value > -0.3:
		return "forest"
	elif value > -0.6:
		return "mountain"
	else:
		return "water"
