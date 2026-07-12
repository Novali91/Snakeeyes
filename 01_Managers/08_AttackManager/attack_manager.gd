class_name AttackManager
extends Node2D

# -1 is start, 48 is end (sorry is bad)
var _attack_ind: int = -1

var _current_attack: BossAttack
var _next_attack: BossAttack

@onready var boss_tooltip: BossTooltip = $BossTooltip
var _boss_round: bool = false
@onready var area: Area2D = $Area

var NORMAL_ATTACKS: Array[BossAttack] = [
	BossAttack.new([2], 0), # 1
	BossAttack.new([3], 0), # 2
	BossAttack.new([2], 0), # 3
	BossAttack.new([2, 4, 5], 0), # 4
	BossAttack.new([3], 0), # 5 
	BossAttack.new([3], 3), # 6 swap charm and strength
	BossAttack.new([5], 0), # 7
	BossAttack.new([2, 4, 7], 0), # 8
	BossAttack.new([6], 0), # 9
	BossAttack.new([8], 0), # 10 
	BossAttack.new([10], 0), # 11
	BossAttack.new([2, 8], 5), # 12 slide back
	BossAttack.new([2, 12], 0), # 13
	BossAttack.new([3, 10], 0), # 14
	BossAttack.new([15], 0), # 15
	BossAttack.new([5, 18], 0), # 16
	BossAttack.new([12], 0), # 17
	BossAttack.new([15], 2), # 18 -strength
	BossAttack.new([6, 20], 0), # 19
	BossAttack.new([23], 0), # 20
	BossAttack.new([26], 0), # 21
	BossAttack.new([8, 16, 20], 0), # 22
	BossAttack.new([30], 0), # 23
	BossAttack.new([2, 16], 8), # 24 snakes +1 psn
	BossAttack.new([36], 0), # 25
	BossAttack.new([10, 40], 0), # 26
	BossAttack.new([30], 0), # 27
	BossAttack.new([10, 45], 0), # 28
	BossAttack.new([50], 0), # 29
	BossAttack.new([15, 50], 6), # 30 kill snakes at end (maybe crashes?)
	BossAttack.new([60], 0), # 31
	BossAttack.new([20, 70], 0), # 32
	BossAttack.new([10, 50], 0), # 33
	BossAttack.new([80], 0), # 34
	BossAttack.new([75], 0), # 35
	BossAttack.new([5, 20, 40, 120], 10), # 36
	BossAttack.new([5, 20, 40, 120], 10), # 37!!!
]

var HARD_ATTACKS: Array[BossAttack] = [
	BossAttack.new([2], 0), # 1
	BossAttack.new([3], 0), # 2
	BossAttack.new([2], 0), # 3
	BossAttack.new([2, 4, 5], 0), # 4
	BossAttack.new([3], 0), # 5 
	BossAttack.new([3], 3), # 6 swap charm and strength
	BossAttack.new([5], 0), # 7
	BossAttack.new([2, 4, 7], 0), # 8
	BossAttack.new([6], 0), # 9
	BossAttack.new([8], 0), # 10 
	BossAttack.new([10], 0), # 11
	BossAttack.new([2, 8], 5), # 12 slide back
	BossAttack.new([2, 12], 0), # 13
	BossAttack.new([3, 10], 0), # 14
	BossAttack.new([15], 0), # 15
	BossAttack.new([5, 18], 0), # 16
	BossAttack.new([12], 0), # 17
	BossAttack.new([15], 2), # 18 -strength
	BossAttack.new([6, 20], 0), # 19
	BossAttack.new([23], 0), # 20
	BossAttack.new([26], 0), # 21
	BossAttack.new([8, 16, 20], 0), # 22
	BossAttack.new([30], 0), # 23
	BossAttack.new([2, 16], 8), # 24 snakes +1 psn
	BossAttack.new([36], 0), # 25
	BossAttack.new([10, 40], 0), # 26
	BossAttack.new([30], 0), # 27
	BossAttack.new([10, 45], 0), # 28
	BossAttack.new([50], 0), # 29
	BossAttack.new([15, 50], 6), # 30 kill snakes at end (maybe crashes?)
	BossAttack.new([60], 0), # 31
	BossAttack.new([20, 70], 0), # 32
	BossAttack.new([10, 50], 0), # 33
	BossAttack.new([80], 0), # 34
	BossAttack.new([75], 0), # 35
	BossAttack.new([5, 20, 40, 120], 10), # 36
	BossAttack.new([5, 20, 40, 120], 10), # 37!!!
]

## Maybe do more 2-hit attacks, especially when it jumps
## Mayb more dipping attacks to mitigate rng
var ATTACK_LIST: Array[BossAttack] = HARD_ATTACKS

func _ready() -> void:
	modulate.a = 0.0
	
	area.mouse_entered.connect(_attack_hovered)
	area.mouse_exited.connect(_attack_unhovered)

func next_attack() -> void:
	
	if _boss_round:
		boss_tooltip.deactivate_boss_attack_tooltip()
	
	_attack_ind += 1
	_current_attack = ATTACK_LIST[_attack_ind]
	_next_attack = ATTACK_LIST[_attack_ind + 1]
	
	if _current_attack.ability_index != 0:
		_boss_round = true
		boss_tooltip.start_boss_round(_current_attack.ability_index, 0)
	else:
		_boss_round = false
		
		var n = _attack_ind
		while ATTACK_LIST[n].ability_index == 0: n += 1
		boss_tooltip.activate_boss_attack_tooltip(ATTACK_LIST[n].ability_index, n - _attack_ind)
	#boss_tooltip.cur_string = boss_tooltip.pick_convo_string()
	#boss_tooltip.convo.text = boss_tooltip.cur_string

func get_attack() -> BossAttack:
	return _current_attack

func get_attack_goal() -> int:
	var out = 0
	for i in _current_attack.damage:
		out += i
	return out

func _attack_hovered() -> void:
	if _boss_round:
		return
	
	var n = _attack_ind
	while ATTACK_LIST[n].ability_index == 0: n += 1
	
	boss_tooltip.hover_tooltip(ATTACK_LIST[n].ability_index, n - _attack_ind)
	
	GS.attack_hovered.emit()

func _attack_unhovered() -> void:
	if _boss_round:
		return
	
	boss_tooltip.unhover_tooltip()
	
	GS.attack_unhovered.emit()

## Drinking a drink gives all drinks -1 str - HandManager
## Swap charm and strength - Play state
## Draw 1 on drink - Play state
## On drink, slide 1 back - Play state
## End of turn, kill each snakes for drink in hand - Hand Manager
## Swap poison and charm
## Round 5 - Meet this score exactly
## Final: If you don't beat this, redo the round
## 
