extends Line2D

@export var move_speed: float = 70.0
@export var wait_time: float = 1.0

@onready var vehicle_sprite_east: Sprite2D = $VehicleSprite_East
@onready var vehicle_sprite_west: Sprite2D = $VehicleSprite_West
@onready var vehicle_sprite_north: Sprite2D = $VehicleSprite_North
@onready var vehicle_sprite_south: Sprite2D = $VehicleSprite_South

@onready var load: Sprite2D = $Load

var load_east: Vector2 = Vector2(-24, -10)
var load_west: Vector2 = Vector2(7, -10)
var load_north: Vector2 = Vector2(-10, 4)
var load_south: Vector2 = Vector2(-9, -21)

var _active_sprite: Sprite2D
var _is_forward: bool = true


func _ready() -> void:
	if not Engine.is_editor_hint():
		width = 0

	if points.size() < 2:
		return

	_set_active_sprite(vehicle_sprite_east)
	_set_vehicle_position(points[0])
	load.visible = false

	_move_loop()
	
	


func _move_loop() -> void:
	while true:
		_is_forward = true
		load.visible = true

		for i in range(1, points.size()):
			await _move_to(points[i])

		await get_tree().create_timer(wait_time).timeout

		_is_forward = false
		load.visible = false

		for i in range(points.size() - 2, -1, -1):
			await _move_to(points[i])

		await get_tree().create_timer(wait_time).timeout


func _move_to(target: Vector2) -> void:
	while _active_sprite.position.distance_to(target) > 1.0:
		var direction: Vector2 = _active_sprite.position.direction_to(target)

		_update_direction_sprite(direction)

		_set_vehicle_position(
			_active_sprite.position
			+ direction * move_speed * get_process_delta_time()
		)

		await get_tree().process_frame

	_set_vehicle_position(target)


func _update_direction_sprite(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			_set_active_sprite(vehicle_sprite_east)
			load.position = _active_sprite.position + load_east
		else:
			_set_active_sprite(vehicle_sprite_west)
			load.position = _active_sprite.position + load_west
	else:
		if direction.y > 0:
			_set_active_sprite(vehicle_sprite_south)
			load.position = _active_sprite.position + load_south
		else:
			_set_active_sprite(vehicle_sprite_north)
			load.position = _active_sprite.position + load_north


func _set_active_sprite(sprite: Sprite2D) -> void:
	vehicle_sprite_east.visible = sprite == vehicle_sprite_east
	vehicle_sprite_west.visible = sprite == vehicle_sprite_west
	vehicle_sprite_north.visible = sprite == vehicle_sprite_north
	vehicle_sprite_south.visible = sprite == vehicle_sprite_south

	_active_sprite = sprite


func _set_vehicle_position(pos: Vector2) -> void:
	vehicle_sprite_east.position = pos
	vehicle_sprite_west.position = pos
	vehicle_sprite_north.position = pos
	vehicle_sprite_south.position = pos

	if _is_forward:
		load.position = pos + _get_load_offset()


func _get_load_offset() -> Vector2:
	if _active_sprite == vehicle_sprite_east:
		return load_east
	elif _active_sprite == vehicle_sprite_west:
		return load_west
	elif _active_sprite == vehicle_sprite_north:
		return load_north
	else:
		return load_south
