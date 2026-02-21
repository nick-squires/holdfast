# HexTile.gd — Single hex tile: mesh + Area3D for click detection
extends Node3D

var hex_coord: Vector2i = Vector2i.ZERO
var tile_type: String = "grass"
var decorations: Array[Node3D] = []

@onready var area: Area3D = $Area3D


func _ready() -> void:
	area.input_event.connect(_on_input_event)
	area.mouse_entered.connect(_on_mouse_entered)


func setup(coord: Vector2i, type: String) -> void:
	hex_coord = coord
	tile_type = type

	# Load and add the tile mesh
	var terrain_data: Dictionary = DataLoader.terrain.get(type, {})
	var tile_key: String = terrain_data.get("tile_key", "tile_grass")
	var tile_scene: Node3D = AssetRegistry.instance_mesh(tile_key)
	add_child(tile_scene)

	# Add decorations based on terrain type
	var decor_keys: Array = terrain_data.get("decorations", [])
	if decor_keys.size() > 0:
		_add_decorations(decor_keys)


func _add_decorations(decor_keys: Array) -> void:
	# Add 1-3 random decorations for forest/mountain tiles
	var rng := RandomNumberGenerator.new()
	rng.seed = hash(hex_coord)
	var count: int = rng.randi_range(1, mini(3, decor_keys.size()))

	for i in range(count):
		var key: String = decor_keys[rng.randi() % decor_keys.size()]
		var decor: Node3D = AssetRegistry.instance_mesh(key)
		# Small random offset within the hex
		var offset_x: float = rng.randf_range(-0.3, 0.3)
		var offset_z: float = rng.randf_range(-0.3, 0.3)
		decor.position = Vector3(offset_x, 0, offset_z)
		# Random Y rotation
		decor.rotation.y = rng.randf_range(0, TAU)
		add_child(decor)
		decorations.append(decor)


func clear_decorations() -> void:
	for decor in decorations:
		decor.queue_free()
	decorations.clear()


func _on_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		SignalBus.tile_clicked.emit(hex_coord)


func _on_mouse_entered() -> void:
	SignalBus.tile_hovered.emit(hex_coord)
