# WaveSpawner.gd — Reads waves.json, spawns on outer ring
extends Node

var active_enemies: Array = []
var current_wave: int = 0


func _ready() -> void:
	SignalBus.night_started.connect(_on_night_started)


func _on_night_started(wave_data: Dictionary) -> void:
	if wave_data.is_empty():
		return
	current_wave = wave_data.get("night", 0)
	if wave_data.get("is_siege", false):
		SignalBus.siege_wave_started.emit()
	# TODO: Spawn enemies on outer ring hexes
	# For each enemy group in wave_data["enemies"], instance skeleton units
	# and place them on random tiles in the outermost hex ring


func check_wave_clear() -> void:
	# Called each frame or on enemy death — checks if all enemies are dead
	active_enemies = active_enemies.filter(func(e): return not e.is_dead)
	if active_enemies.is_empty() and current_wave > 0:
		SignalBus.wave_cleared.emit(current_wave, 0, 0)
		current_wave = 0
