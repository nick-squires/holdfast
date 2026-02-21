# Skeleton.gd — Extends Unit; has pathfinding to target
extends "res://entities/units/Unit.gd"

var target_coord: Vector2i = Vector2i.ZERO
var target_priority: String = "center"
var path: Array[Vector2i] = []
var path_index: int = 0


func setup(type_id: String, coord: Vector2i) -> void:
	super.setup(type_id, coord)
	var data: Dictionary = DataLoader.get_unit(type_id)
	target_priority = data.get("target_priority", "center")
