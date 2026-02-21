# Building.gd — Base building: @export mesh_key, @export data_id
extends Node3D

@export var mesh_key: String = ""
@export var data_id: String = ""

var hp: int = 0
var max_hp: int = 0
var hex_coord: Vector2i = Vector2i.ZERO
var workers: Array = []
var is_destroyed: bool = false


func setup(building_id: String, coord: Vector2i) -> void:
	data_id = building_id
	hex_coord = coord
	var data: Dictionary = DataLoader.get_building(building_id)
	mesh_key = data.get("mesh_key", "")
	max_hp = data.get("hp", 50)
	hp = max_hp

	# Instance the building mesh
	if mesh_key != "":
		var mesh_node: Node3D = AssetRegistry.instance_mesh(mesh_key)
		add_child(mesh_node)


func take_damage(amount: int) -> void:
	hp -= amount
	if hp <= 0:
		hp = 0
		_on_destroyed()


func repair(heal_amount: int) -> void:
	hp = mini(hp + heal_amount, max_hp)
	is_destroyed = false


func _on_destroyed() -> void:
	is_destroyed = true
	SignalBus.building_destroyed.emit(data_id, hex_coord)
