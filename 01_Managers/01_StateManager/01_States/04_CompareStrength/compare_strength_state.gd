class_name CompareStrengthState
extends TopState

func setup() -> void:
	pass

func enter() -> void:
	var player_str = sm.game_stats.strength
	var enemy_str = sm.attack_manager.get_attack()
	
	var attacks_blocked = 0
	for i: int in enemy_str:
		if player_str >= i:
			player_str -= i
			attacks_blocked += 1
		
		else: break
	
	var damage = enemy_str.size() - attacks_blocked
	if damage == 0:
		sm.game_stats.score += 1
	
	else:
		sm.game_stats.score -= damage
	
	sm.score_bar.set_value(sm.game_stats.score)
	
	sm.switch_state(sm.States.SHOP)

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass
