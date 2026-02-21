# MilitaryBuilding.gd — Extends Building; spawns defenders at night
extends "res://entities/buildings/Building.gd"

var defender_type: String = ""
var defender_count: int = 0


func setup(building_id: String, coord: Vector2i) -> void:
	super.setup(building_id, coord)
	var data: Dictionary = DataLoader.get_building(building_id)
	defender_type = data.get("defender_type", "")
	defender_count = data.get("defender_count", 0)


func spawn_defenders() -> Array:
	# Called at night start. Returns array of defender data dictionaries.
	if is_destroyed or defender_type == "":
		return []
	var defenders: Array = []
	for i in range(defender_count):
		defenders.append({
			"type": defender_type,
			"spawn_coord": hex_coord,
		})
	return defenders
