extends Camera2D
class_name MouseCamera2D

@export var target_tilemap: TileMapLayer

@export var drag_speed: float = 1.0

@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 3.0

var _dragging: bool = false


func _ready() -> void:
	_apply_tilemap_limits()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			_dragging = event.pressed

		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				_zoom_camera(1)

			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				_zoom_camera(-1)

	elif event is InputEventMouseMotion and _dragging:
		global_position -= event.relative / zoom * drag_speed
		_clamp_to_tilemap()


func _zoom_camera(direction: int) -> void:
	var mouse_world_before: Vector2 = get_global_mouse_position()

	var zoom_offset: float = zoom_speed * zoom.x
	var new_zoom_value: float = zoom.x + zoom_offset * direction
	new_zoom_value = clamp(new_zoom_value, min_zoom, max_zoom)

	zoom = Vector2(new_zoom_value, new_zoom_value)

	var mouse_world_after: Vector2 = get_global_mouse_position()
	global_position += mouse_world_before - mouse_world_after

	_clamp_to_tilemap()

func _apply_tilemap_limits() -> void:
	if target_tilemap == null:
		return

	var used_rect: Rect2i = target_tilemap.get_used_rect()
	var tile_size: Vector2i = target_tilemap.tile_set.tile_size

	var world_min: Vector2 = target_tilemap.to_global(Vector2(used_rect.position * tile_size))
	var world_max: Vector2 = target_tilemap.to_global(Vector2((used_rect.position + used_rect.size) * tile_size))

	limit_left = int(world_min.x)
	limit_top = int(world_min.y)
	limit_right = int(world_max.x)
	limit_bottom = int(world_max.y)


func _clamp_to_tilemap() -> void:
	if target_tilemap == null:
		return

	var viewport_size: Vector2 = get_viewport_rect().size / zoom
	var half_size: Vector2 = viewport_size * 0.5

	var min_pos := Vector2(limit_left, limit_top) + half_size
	var max_pos := Vector2(limit_right, limit_bottom) - half_size

	global_position.x = clamp(global_position.x, min_pos.x, max_pos.x)
	global_position.y = clamp(global_position.y, min_pos.y, max_pos.y)
