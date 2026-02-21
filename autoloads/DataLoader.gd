# DataLoader.gd — Parses /data/*.json into typed Resources
extends Node

var buildings: Dictionary = {}
var units: Dictionary = {}
var waves: Dictionary = {}
var terrain: Dictionary = {}
var relics: Dictionary = {}
var merchants: Dictionary = {}

func _ready() -> void:
	buildings = _load_json("res://data/buildings.json")
	units = _load_json("res://data/units.json")
	waves = _load_json("res://data/waves.json")
	terrain = _load_json("res://data/terrain.json")
	relics = _load_json("res://data/relics.json")
	merchants = _load_json("res://data/merchants.json")

func _load_json(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		push_warning("DataLoader: file not found: %s" % path)
		return {}
	var file := FileAccess.open(path, FileAccess.READ)
	var text := file.get_as_text()
	var json := JSON.new()
	var error := json.parse(text)
	if error != OK:
		push_error("DataLoader: JSON parse error in %s at line %d: %s" % [path, json.get_error_line(), json.get_error_message()])
		return {}
	return json.data

func get_building(id: String) -> Dictionary:
	return buildings.get(id, {})

func get_wave(night_number: int) -> Dictionary:
	return waves.get(str(night_number), {})

func get_unit(id: String) -> Dictionary:
	return units.get(id, {})
