# MerchantSpawner.gd — Places merchant on day 4 and 6
extends Node

func _ready() -> void:
	SignalBus.day_started.connect(_on_day_started)


func _on_day_started(day_number: int) -> void:
	for merchant_id in DataLoader.merchants:
		var merchant_data: Dictionary = DataLoader.merchants[merchant_id]
		if merchant_data.get("arrives_day", -1) == day_number:
			SignalBus.merchant_arrived.emit(merchant_data)
