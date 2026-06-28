class_name PoisonRollState
extends TopState

func setup() -> void:
	#sm.dice_manager.number_accepted.connect(_check_poison)
	pass

func enter() -> void:
	sm.camera_manager.lock_camera()
	sm.dice_manager.set_poison(GS.get_poison())
	
	if GS.tutorial_index == GS.Tutorial.START:
		sm.dice_manager.in_tutorial = true
		sm.dice_manager.antidote_pressable = false
	
	sm.dice_manager.roll_the_dice(true)
	
	if GS.tutorial_index == GS.Tutorial.START:
		await sm.dice_manager.number_rolled
		await sm.tutorial_manager.dice_rolled()
		sm.dice_manager.antidote_pressable = true
		await sm.dice_manager.antidote_used
		sm.dice_manager.in_tutorial = false
	
	var num: int = await sm.dice_manager.number_accepted
	_check_poison(num)

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func _check_poison(dice_roll: int) -> void:
	sm.dice_manager.close()
	await sm.dice_manager.closed
	
	if dice_roll >= GS.get_poison():
		sm.switch_state(sm.States.COMPARE_STRENGTH)
	
	else:
		sm.switch_state(sm.States.PASS_OUT)
