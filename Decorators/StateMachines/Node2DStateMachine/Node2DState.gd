extends Node
class_name Node2DState

var parent: Node2DStateMachine
var client: Node2D
var is_active: bool = false

func print_enter_state() -> void:
	print(name, ".enter_state()")

func print_uptade() -> void:
	print(name, ".update()")

func initialize(_parent: Node2DStateMachine, _client: Node2D):
	parent = _parent
	client = _client

# Virtual methods
func enter_state(_args = null) -> void:
	pass
	
func exit_state(_args = null) -> void:
	pass

func update(_delta: float) -> void:
	pass
