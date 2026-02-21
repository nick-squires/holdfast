# ResourceManager.gd — Tracks { wood, stone, iron, food, gold, textiles }
extends Node

var amounts: Dictionary = {
	"wood": 100,
	"stone": 50,
	"iron": 0,
	"food": 30,
	"gold": 20,
	"textiles": 0,
}

func _ready() -> void:
	SignalBus.night_started.connect(_on_night_started)

func add(type: String, amount: int) -> void:
	assert(type in amounts, "ResourceManager: unknown resource '%s'" % type)
	amounts[type] += amount
	SignalBus.resource_changed.emit(type, amounts[type])

func spend(type: String, amount: int) -> bool:
	if amounts[type] < amount:
		return false
	amounts[type] -= amount
	SignalBus.resource_changed.emit(type, amounts[type])
	return true

func can_afford(cost: Dictionary) -> bool:
	for type in cost:
		if amounts.get(type, 0) < cost[type]:
			return false
	return true

func spend_cost(cost: Dictionary) -> bool:
	if not can_afford(cost):
		return false
	for type in cost:
		amounts[type] -= cost[type]
		SignalBus.resource_changed.emit(type, amounts[type])
	return true

func apply_upkeep() -> void:
	# Deducts 1 food per adventurer. Called at night start.
	var adventurer_count: int = GameState.adventurers.size()
	if adventurer_count == 0:
		return
	var food_cost: int = adventurer_count
	if amounts["food"] >= food_cost:
		amounts["food"] -= food_cost
		SignalBus.resource_changed.emit("food", amounts["food"])
	else:
		amounts["food"] = 0
		SignalBus.resource_changed.emit("food", 0)
		SignalBus.resource_depleted.emit("food")

func get_repair_cost(original_cost: Dictionary) -> Dictionary:
	# 50% of original build cost, rounded up
	var repair_cost: Dictionary = {}
	for type in original_cost:
		repair_cost[type] = ceili(original_cost[type] * 0.5)
	return repair_cost

func reset() -> void:
	amounts = {
		"wood": 100,
		"stone": 50,
		"iron": 0,
		"food": 30,
		"gold": 20,
		"textiles": 0,
	}

func _on_night_started(_wave_data: Dictionary) -> void:
	apply_upkeep()
