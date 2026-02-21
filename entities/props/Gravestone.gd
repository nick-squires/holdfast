# Gravestone.gd — Handles rise/sink tween
extends Node3D

var hex_coord: Vector2i = Vector2i.ZERO
var is_risen: bool = false


func rise(duration: float = 1.5) -> void:
	position.y = -1.0
	var tween := create_tween()
	tween.tween_property(self, "position:y", 0.0, duration)
	tween.finished.connect(func(): is_risen = true)


func sink(duration: float = 1.0) -> void:
	var tween := create_tween()
	tween.tween_property(self, "position:y", -1.0, duration)
	tween.finished.connect(func():
		is_risen = false
		queue_free()
	)
