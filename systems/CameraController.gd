# CameraController.gd — Isometric free-roam, zoom, edge-pan
extends Camera3D

# Pan settings
@export var pan_speed: float = 15.0
@export var edge_pan_margin: float = 30.0
@export var edge_pan_enabled: bool = true

# Zoom settings
@export var zoom_speed: float = 2.0
@export var zoom_min: float = 5.0
@export var zoom_max: float = 25.0

# Isometric camera angle (fixed)
@export var camera_height: float = 12.0
@export var camera_angle: float = -55.0  # Degrees, looking down
@export var camera_rotation_y: float = -30.0  # Degrees, rotated for isometric

# Internal state
var _target_position: Vector3 = Vector3.ZERO
var _current_zoom: float = 15.0

# Map bounds (set by HexMap after generation)
var map_bounds_min: Vector3 = Vector3(-5, 0, -5)
var map_bounds_max: Vector3 = Vector3(30, 0, 25)


func _ready() -> void:
	# Set initial isometric orientation
	rotation_degrees = Vector3(camera_angle, camera_rotation_y, 0)
	_current_zoom = camera_height
	_update_camera_position()


func _process(delta: float) -> void:
	var pan_input := Vector3.ZERO

	# Keyboard panning (WASD / arrow keys)
	if Input.is_action_pressed("ui_up"):
		pan_input.z -= 1.0
	if Input.is_action_pressed("ui_down"):
		pan_input.z += 1.0
	if Input.is_action_pressed("ui_left"):
		pan_input.x -= 1.0
	if Input.is_action_pressed("ui_right"):
		pan_input.x += 1.0

	# Edge panning
	if edge_pan_enabled:
		var viewport_size := get_viewport().get_visible_rect().size
		var mouse_pos := get_viewport().get_mouse_position()
		if mouse_pos.x < edge_pan_margin:
			pan_input.x -= 1.0
		elif mouse_pos.x > viewport_size.x - edge_pan_margin:
			pan_input.x += 1.0
		if mouse_pos.y < edge_pan_margin:
			pan_input.z -= 1.0
		elif mouse_pos.y > viewport_size.y - edge_pan_margin:
			pan_input.z += 1.0

	# Apply panning (rotate input to match camera orientation)
	if pan_input.length_squared() > 0:
		pan_input = pan_input.normalized()
		# Rotate pan direction to match camera's Y rotation
		var rot := deg_to_rad(-camera_rotation_y)
		var rotated_x := pan_input.x * cos(rot) - pan_input.z * sin(rot)
		var rotated_z := pan_input.x * sin(rot) + pan_input.z * cos(rot)
		_target_position.x += rotated_x * pan_speed * delta
		_target_position.z += rotated_z * pan_speed * delta

	# Clamp to map bounds
	_target_position.x = clampf(_target_position.x, map_bounds_min.x, map_bounds_max.x)
	_target_position.z = clampf(_target_position.z, map_bounds_min.z, map_bounds_max.z)

	_update_camera_position()


func _unhandled_input(event: InputEvent) -> void:
	# Mouse wheel zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			_current_zoom = maxf(_current_zoom - zoom_speed, zoom_min)
			_update_camera_position()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			_current_zoom = minf(_current_zoom + zoom_speed, zoom_max)
			_update_camera_position()


func _update_camera_position() -> void:
	# Position camera above and behind the target point
	var offset := Vector3(0, _current_zoom, 0)
	# Apply the pitch to calculate the actual camera offset
	var pitch_rad := deg_to_rad(-camera_angle)
	offset.z = _current_zoom * cos(pitch_rad)
	offset.y = _current_zoom * sin(pitch_rad)
	# Apply yaw rotation
	var yaw_rad := deg_to_rad(camera_rotation_y)
	var final_offset := Vector3(
		offset.z * sin(yaw_rad),
		offset.y,
		offset.z * cos(yaw_rad)
	)
	position = _target_position + final_offset


func center_on(world_pos: Vector3) -> void:
	_target_position = Vector3(world_pos.x, 0, world_pos.z)
	_update_camera_position()


func set_map_bounds(min_pos: Vector3, max_pos: Vector3) -> void:
	map_bounds_min = min_pos
	map_bounds_max = max_pos
