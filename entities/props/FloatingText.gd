# FloatingText.gd — "+30 wood" resource feedback
extends Node3D

@onready var label: Label3D = $Label3D


func show_text(text: String, color: Color = Color.WHITE, duration: float = 1.5) -> void:
	if label:
		label.text = text
		label.modulate = color

	# Float upward and fade out
	var tween := create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "position:y", position.y + 1.5, duration)
	tween.tween_property(self, "modulate:a", 0.0, duration).set_delay(duration * 0.5)
	tween.finished.connect(queue_free)
