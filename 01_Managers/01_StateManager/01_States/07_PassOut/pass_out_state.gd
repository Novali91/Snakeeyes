class_name PassOutState
extends TopState

func setup() -> void:
	pass

func enter() -> void:
	var damage = sm.attack_manager.get_attack().size()
	GS.score -= damage
	sm.score_bar.set_value(GS.score)
	sm.switch_state(sm.States.SETUP_TURN)

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass
