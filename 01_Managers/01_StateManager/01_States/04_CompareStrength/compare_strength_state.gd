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
		GS.set_score(cur_score + 1)
	
	else:
		GS.set_score(cur_score - damage)
	
	sm.switch_state(sm.States.SHOP)

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass
