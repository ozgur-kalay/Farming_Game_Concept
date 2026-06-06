extends Node2DState

@export var move_speed: float = 20.0
@export var roam_radius: float = 100.0
@export var wait_min: float = 3.0
@export var wait_max: float = 15.0
@export var arrive_distance: float = 4.0

var _target: Vector2
var _origin: Vector2

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"


func enter_state(_args = null) -> void:
	animated_sprite_2d.play("walk")

	var animal := parent.owner

	_origin = animal.global_position

	var angle := randf() * TAU
	var distance := randf() * roam_radius

	_target = (
		_origin
		+ Vector2.RIGHT.rotated(angle) * distance
	)


func update(delta: float) -> void:
	var animal := parent.owner

	var direction := client.global_position.direction_to(_target)

	# Flip sprite when moving left
	animated_sprite_2d.flip_h = direction.x < 0

	animal.global_position += (
		direction
		* move_speed
		* delta
	)

	if animal.global_position.distance_to(_target) <= arrive_distance:
		parent.change_state("IdleState")


func exit_state(_args = null) -> void:
	pass
