# ProductionBuilding.gd — Extends Building; handles resource tick
extends "res://entities/buildings/Building.gd"

var output_resource: String = ""
var output_per_day: int = 0
var conditional_resource: String = ""
var conditional_per_day: int = 0
var conditional_unlock_day: int = -1
var worker_bonus_unit: String = ""
var worker_bonus_multiplier: float = 1.0


func setup(building_id: String, coord: Vector2i) -> void:
	super.setup(building_id, coord)
	var data: Dictionary = DataLoader.get_building(building_id)
	var output: Variant = data.get("output", null)
	if output is Dictionary:
		output_resource = output.get("resource", "")
		output_per_day = output.get("per_day", 0)
	var conditional: Variant = data.get("conditional_output", null)
	if conditional is Dictionary:
		conditional_resource = conditional.get("resource", "")
		conditional_per_day = conditional.get("per_day", 0)
		conditional_unlock_day = conditional.get("unlock_day", -1)
	var bonus: Variant = data.get("worker_bonus", null)
	if bonus is Dictionary:
		worker_bonus_unit = bonus.get("unit", "")
		worker_bonus_multiplier = bonus.get("multiplier", 1.0)


func produce() -> void:
	if is_destroyed or output_resource == "":
		return
	var amount: int = output_per_day
	# Apply worker bonus
	amount = _apply_worker_bonus(amount)
	ResourceManager.add(output_resource, amount)
	# Conditional output (e.g., iron from mine on day 3+)
	if conditional_resource != "" and GameState.day_number >= conditional_unlock_day:
		var cond_amount: int = _apply_worker_bonus(conditional_per_day)
		ResourceManager.add(conditional_resource, cond_amount)


func _apply_worker_bonus(base_amount: int) -> int:
	if worker_bonus_unit == "" or workers.is_empty():
		return base_amount
	var bonus_count: int = 0
	for worker in workers:
		if worker.get("type", "") == worker_bonus_unit:
			bonus_count += 1
	if bonus_count > 0:
		return roundi(base_amount * worker_bonus_multiplier)
	return base_amount
