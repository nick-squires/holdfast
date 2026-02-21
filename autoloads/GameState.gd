# GameState.gd — Day number, phase, settlement HP, run flags
extends Node

enum Phase { DAY, DUSK, NIGHT, DAWN }

var day_number: int = 1
var current_phase: Phase = Phase.DAY
var settlement_hp: int = 100
var settlement_max_hp: int = 100
var is_game_over: bool = false
var is_victory: bool = false

# Great Hall construction progress (0–3 days)
var great_hall_progress: int = 0
var great_hall_unlocked: bool = false

# Track all adventurers
var adventurers: Array = []

# Map data: { Vector2i: { "type": String, "building": Variant, "units": Array } }
var tile_data: Dictionary = {}

func reset() -> void:
	day_number = 1
	current_phase = Phase.DAY
	settlement_hp = 100
	settlement_max_hp = 100
	is_game_over = false
	is_victory = false
	great_hall_progress = 0
	great_hall_unlocked = false
	adventurers.clear()
	tile_data.clear()
