class_name PassOutState
extends TopState

func setup() -> void:
	pass

func enter() -> void:
	var damage = sm.attack_manager.get_attack().size()
	sm.game_stats.score -= damage
	sm.score_bar.set_value(sm.game_stats.score)
	sm.switch_state(sm.States.SETUP_TURN)

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass
