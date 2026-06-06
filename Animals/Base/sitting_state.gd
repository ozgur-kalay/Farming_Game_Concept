extends Node2DState

@export var sit_min: float = 5.0
@export var sit_max: float = 20.0

var _active: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

func enter_state(_args = null) -> void:
	_active = true

	animated_sprite_2d.play("sitting")

	_wait()


func exit_state(_args = null) -> void:
	_active = false


func _wait() -> void:
	await get_tree().create_timer(
		randf_range(sit_min, sit_max)
	).timeout

	if not _active:
		return

	parent.change_state("IdleState")
