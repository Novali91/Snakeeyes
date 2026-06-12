class_name SetupTurnState
extends TopState

func setup() -> void:
	pass

func enter() -> void:
	sm.camera_manager.switch_screen(sm.camera_manager.MIDDLE, true)
	sm.camera_manager.lock_camera()
	_reset_stats()
	
	sm.shop_manager.empty_shop()
	sm.shop_manager.fill_shop()
	
	sm.attack_manager.next_attack()
	sm.score_bar.set_goal_value(sm.attack_manager.get_attack_goal())
	
	GS.turn_count += 1
	sm.score_bar.set_turn_value(GS.turn_count)
	
	await get_tree().create_timer(0.5).timeout
	
	sm.switch_state(sm.States.PLAY)

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func _reset_stats() -> void:
	GS.set_poison(1)
	GS.set_strength(0)
	GS.set_charm(0)
	
	sm.charm_overlay.clear_charm()
