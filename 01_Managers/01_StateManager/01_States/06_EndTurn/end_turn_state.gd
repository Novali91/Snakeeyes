class_name EndTurnState
extends TopState

func setup() -> void:
	pass

func enter() -> void:
	sm.switch_state(sm.States.SETUP_TURN)

func exit() -> void:
	GS.in_tutorial = false

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass
