extends Node2DState

@export var wait_min: float = 3.0
@export var wait_max: float = 15.0
@onready var animated_sprite_2d: AnimatedSprite2D = $"../../AnimatedSprite2D"

var _active: bool = false


func enter_state(_args = null) -> void:
	_active = true

	animated_sprite_2d.play("idle")

	_wait()


func exit_state(_args = null) -> void:
	_active = false


func _wait() -> void:
	await get_tree().create_timer(
		randf_range(wait_min, wait_max)
	).timeout

	if not _active:
		return

	match randi_range(0, 2):
		0:
			parent.change_state("WalkState")
		1:
			parent.change_state("EatState")
		2:
			parent.change_state("SittingState")
