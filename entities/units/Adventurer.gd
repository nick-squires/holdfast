# Adventurer.gd — Extends Unit; has assignment + night behavior
extends "res://entities/units/Unit.gd"

var assigned_building: String = ""
var is_working: bool = false


func assign_to_building(building_id: String) -> void:
	assigned_building = building_id
	is_working = true
	SignalBus.unit_assigned.emit(get_instance_id(), building_id)


func unassign() -> void:
	assigned_building = ""
	is_working = false
