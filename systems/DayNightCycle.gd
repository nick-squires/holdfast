# DayNightCycle.gd — State machine, owns the cycle timer
extends Node

@export var day_duration: float = 60.0  # seconds
@export var dusk_duration: float = 10.0
@export var dawn_duration: float = 10.0

var phase_timer: float = 0.0
var is_night_active: bool = false


func _ready() -> void:
	SignalBus.wave_cleared.connect(_on_wave_cleared)
	_enter_phase(GameState.Phase.DAY)


func _process(delta: float) -> void:
	match GameState.current_phase:
		GameState.Phase.DAY:
			phase_timer -= delta
			if phase_timer <= 0:
				_enter_phase(GameState.Phase.DUSK)
		GameState.Phase.DUSK:
			phase_timer -= delta
			if phase_timer <= 0:
				_enter_phase(GameState.Phase.NIGHT)
		GameState.Phase.NIGHT:
			pass  # Night ends via wave_cleared signal
		GameState.Phase.DAWN:
			phase_timer -= delta
			if phase_timer <= 0:
				GameState.day_number += 1
				_enter_phase(GameState.Phase.DAY)


func _enter_phase(phase: GameState.Phase) -> void:
	GameState.current_phase = phase
	SignalBus.phase_changed.emit(GameState.Phase.keys()[phase])

	match phase:
		GameState.Phase.DAY:
			phase_timer = day_duration
			SignalBus.day_started.emit(GameState.day_number)
		GameState.Phase.DUSK:
			phase_timer = dusk_duration
			SignalBus.dusk_started.emit(GameState.day_number)
		GameState.Phase.NIGHT:
			is_night_active = true
			ResourceManager.apply_upkeep()
			var wave_data: Dictionary = DataLoader.get_wave(GameState.day_number)
			SignalBus.night_started.emit(wave_data)
		GameState.Phase.DAWN:
			phase_timer = dawn_duration
			is_night_active = false
			SignalBus.dawn_started.emit(GameState.day_number)


func _on_wave_cleared(_wave_number: int, _survivors: int, _losses: int) -> void:
	if GameState.current_phase == GameState.Phase.NIGHT:
		_enter_phase(GameState.Phase.DAWN)
