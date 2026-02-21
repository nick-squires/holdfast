# SignalBus.gd — All cross-system signals declared here
extends Node

# Tiles
signal tile_clicked(hex_coord: Vector2i)
signal tile_hovered(hex_coord: Vector2i)

# Buildings
signal building_placed(building_id: String, hex_coord: Vector2i)
signal building_destroyed(building_id: String, hex_coord: Vector2i)
signal building_repaired(building_id: String, hex_coord: Vector2i)

# Resources
signal resource_changed(type: String, new_amount: int)
signal resource_depleted(type: String)

# Units
signal unit_hired(unit_type: String)
signal unit_died(unit_type: String, hex_coord: Vector2i)
signal unit_assigned(unit_id: int, building_id: String)

# Day/Night cycle
signal day_started(day_number: int)
signal night_started(wave_data: Dictionary)
signal dusk_started(day_number: int)
signal dawn_started(day_number: int)
signal phase_changed(new_phase: String)

# Waves
signal wave_cleared(wave_number: int, survivors: int, losses: int)
signal siege_wave_started()

# Great Hall
signal great_hall_completed()

# UI
signal tooltip_requested(data: Dictionary)
signal merchant_arrived(merchant_data: Dictionary)
signal relic_acquired(relic_id: String)
