class_name CompareStrengthState
extends TopState

func setup() -> void:
	pass

func enter() -> void:
	var player_str = GS.strength
	var enemy_str = sm.attack_manager.get_attack()
	
	var attacks_blocked = 0
	for i: int in enemy_str:
		if player_str >= i:
			player_str -= i
			attacks_blocked += 1
		
		else: break
	
	var damage = enemy_str.size() - attacks_blocked
	if damage == 0:
		GS.score += 1
	
	else:
		GS.score -= damage
	
	sm.score_bar.set_value(GS.score)
	
	sm.switch_state(sm.States.SHOP)

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass
