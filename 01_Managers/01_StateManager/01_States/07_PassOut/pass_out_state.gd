class_name PassOutState
extends TopState



func setup() -> void:
	pass

func enter() -> void:
	var damage = sm.attack_manager.get_attack().damage.size()
	GS.set_score(GS.get_score() - damage)
	sm.camera_manager.start_pass_out()
	await(sm.camera_manager.pass_out_complete)
	GS.sound_manager.play_fall()
	sm.switch_state(sm.States.SETUP_TURN)
	

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass
