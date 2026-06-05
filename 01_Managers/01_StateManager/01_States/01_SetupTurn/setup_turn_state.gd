class_name SetupTurnState
extends TopState

func setup() -> void:
	pass

func enter() -> void:
	sm.camera_manager.switch_screen(sm.camera_manager.MIDDLE)
	sm.camera_manager.lock_camera()
	_reset_stats()
	
	sm.shop_manager.empty_shop()
	sm.shop_manager.fill_shop()
	
	sm.attack_manager.next_attack()
	
	await get_tree().create_timer(0.5).timeout
	
	sm.switch_state(sm.States.PLAY)

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func _reset_stats() -> void:
	GS.poison = 1
	GS.strength = 0
	GS.charm = 0
	
	sm.poison_bar.set_value(GS.poison)
	sm.player_strength.set_value(GS.strength)
	
	sm.charm_overlay.clear_charm()
