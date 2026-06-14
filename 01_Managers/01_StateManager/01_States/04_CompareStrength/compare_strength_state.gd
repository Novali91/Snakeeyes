class_name CompareStrengthState
extends TopState

const EXACT_SCORE: int = 6 

func setup() -> void:
	pass

func enter() -> void:
	var player_str = GS.get_strength()
	var enemy_str = sm.attack_manager.get_attack().damage
	
	var attacks_blocked = 0
	if GS.cur_attack_index == EXACT_SCORE:
		for i: int in enemy_str:
			if player_str == i:
				player_str -= i
				attacks_blocked += 1
		pass
	else:
		for i: int in enemy_str:
			if player_str >= i:
				player_str -= i
				attacks_blocked += 1
		
			else: break
	
	var cur_score = GS.get_score()
	
	var damage = enemy_str.size() - attacks_blocked
	
	if damage == 0:
		sm.lady.win_armwrestle()
		await sm.lady.finished
		
		var new_score = min(cur_score + 1, 6)
		GS.set_score(new_score)
	
	else:
		sm.lady.lose_armwrestle(damage)
		await sm.lady.finished
		
		GS.set_score(cur_score - damage)
		
		if GS.get_score() <= 0:
			
			sm.camera_manager.start_pass_out()
			await(sm.camera_manager.pass_out_complete)
			GS.sound_manager.play_fall()
			sm.lose()
			return
	
	await get_tree().create_timer(1.5).timeout
	
	sm.lady.idle()
	
	sm.switch_state(sm.States.SHOP)

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass
