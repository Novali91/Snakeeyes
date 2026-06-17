class_name PassOutState
extends TopState



func setup() -> void:
	pass

func enter() -> void:
	GS.set_charm(0)
	sm.charm_overlay.clear_charm()
	
	GS.set_strength(0)
	GS.set_poison(0)
	
	sm.camera_manager.start_pass_out()
	await(sm.camera_manager.pass_out_complete)
	GS.sound_manager.play_fall()
	
	if GS.get_score() <= 0:
		sm.lose()
		return
	
	sm.switch_state(sm.States.COMPARE_STRENGTH)
	

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass
