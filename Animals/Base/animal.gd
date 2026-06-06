extends Node2D

@export var move_speed: float = 30.0
@export var roam_radius: float = 150.0
@export var wait_min: float = 3.0
@export var wait_max: float = 15.0
@export var arrive_distance: float = 4.0

var _home_position: Vector2
var _target_position: Vector2
var _waiting: bool = false


func _ready() -> void:
	randomize()

	_home_position = global_position

	if randf() < 0.5:
		_wait_then_move()
	else:
		_pick_new_target()


func _process(delta: float) -> void:
	if _waiting:
		return

	var direction: Vector2 = global_position.direction_to(_target_position)

	global_position += direction * move_speed * delta

	if global_position.distance_to(_target_position) <= arrive_distance:
		_wait_then_move()


func _pick_new_target() -> void:
	var angle: float = randf() * TAU
	var distance: float = randf() * roam_radius

	_target_position = (
		_home_position
		+ Vector2.RIGHT.rotated(angle) * distance
	)


func _wait_then_move() -> void:
	_waiting = true

	await get_tree().create_timer(
		randf_range(wait_min, wait_max)
	).timeout

	_waiting = false
	_pick_new_target()
