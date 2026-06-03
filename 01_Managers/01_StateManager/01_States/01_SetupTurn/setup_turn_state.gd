class_name SetupTurnState
extends TopState

func setup() -> void:
	pass

func enter() -> void:
	sm.camera_manager.camera_locked = true
	_reset_stats()
	sm.switch_state(sm.States.PLAY)

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func _reset_stats() -> void:
	sm.game_stats.poison = 1
	sm.game_stats.strength = 0
	sm.game_stats.charm = 0
	
	sm.poison_bar.set_value(sm.game_stats.poison)
	sm.player_strength.set_value(sm.game_stats.strength)
	sm.charm_overlay.set_value(sm.game_stats.charm)
