class_name PoisonRollState
extends TopState

func setup() -> void:
	sm.dice_manager.antidote_used.connect(_reroll)
	sm.dice_manager.number_accepted.connect(_check_poison)

func enter() -> void:
	sm.camera_manager.lock_camera()
	sm.dice_manager.start_roll()

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func _reroll() -> void:
	if sm.game_stats.antidote_num > 0:
		sm.game_stats.antidote_num -= 1
		sm.antidote_count.set_value(sm.game_stats.antidote_num)
		sm.dice_manager.reroll()

func _check_poison(dice_roll: int) -> void:
	if dice_roll > sm.game_stats.poison:
		sm.dice_manager.close()
		sm.switch_state(sm.States.COMPARE_STRENGTH)
	
	else:
		sm.dice_manager.close()
		sm.switch_state(sm.States.PASS_OUT)
