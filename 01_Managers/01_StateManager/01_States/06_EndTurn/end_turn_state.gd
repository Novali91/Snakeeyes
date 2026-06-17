class_name EndTurnState
extends TopState

func setup() -> void:
	pass

func enter() -> void:
	sm.switch_state(sm.States.SETUP_TURN)

func exit() -> void:
	if GS.tutorial_index != GS.Tutorial.SKIPPED:
		if GS.tutorial_index == GS.Tutorial.MULTI_GOAL:
			GS.tutorial_index = GS.Tutorial.SKIPPED
		
		else:
			GS.tutorial_index = GS.Tutorial.NONE

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass
