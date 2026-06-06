extends Node2DState

@export var eat_min: float = 3.0
@export var eat_max: float = 10.0

var _active: bool = false
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"


func enter_state(_args = null) -> void:
	_active = true

	animated_sprite_2d.play("eat")

	_wait()


func exit_state(_args = null) -> void:
	_active = false


func _wait() -> void:
	await get_tree().create_timer(
		randf_range(eat_min, eat_max)
	).timeout

	if not _active:
		return

	parent.change_state("IdleState")
