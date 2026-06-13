class_name PoisonRollState
extends TopState

func setup() -> void:
	#sm.dice_manager.number_accepted.connect(_check_poison)
	pass

func enter() -> void:
	sm.camera_manager.lock_camera()
	sm.dice_manager.set_poison(GS.get_poison())
	sm.dice_manager.start_roll(true,true)
	var num: int = await sm.dice_manager.number_accepted
	_check_poison(num)

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func _check_poison(dice_roll: int) -> void:
	if dice_roll >= GS.get_poison():
		sm.dice_manager.close()
		sm.switch_state(sm.States.COMPARE_STRENGTH)
	
	else:
		sm.dice_manager.close()
		sm.switch_state(sm.States.PASS_OUT)
