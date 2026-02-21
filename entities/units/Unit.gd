# Unit.gd — Base unit: health, speed, AnimationTree
extends CharacterBody3D

@export var unit_type: String = ""
@export var mesh_key: String = ""

var hp: int = 0
var max_hp: int = 0
var damage: int = 0
var speed: float = 1.0
var hex_coord: Vector2i = Vector2i.ZERO
var is_dead: bool = false


func setup(type_id: String, coord: Vector2i) -> void:
	unit_type = type_id
	hex_coord = coord
	var data: Dictionary = DataLoader.get_unit(type_id)
	mesh_key = data.get("mesh_key", "")
	max_hp = data.get("hp", 50)
	hp = max_hp
	damage = data.get("damage", 5)
	speed = data.get("speed", 1.0)

	if mesh_key != "":
		var mesh_node: Node3D = AssetRegistry.instance_mesh(mesh_key)
		add_child(mesh_node)


func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		hp = 0
		_on_death()


func _on_death() -> void:
	is_dead = true
	SignalBus.unit_died.emit(unit_type, hex_coord)
