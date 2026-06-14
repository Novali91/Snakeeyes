class_name AttackManager
extends Node2D

var _attack_ind: int = -1

var _current_attack: Array[int]
var _next_attack: Array[int]

@onready var _input_cur: Label = $Label/InputCur
@onready var _input_next: Label = $Label2/InputNext

var ATTACK_LIST: Array[BossAttack] = [
	BossAttack.new([2], 0), # 1
	BossAttack.new([2], 0), # 2
	BossAttack.new([1, 1], 0), # 3
	BossAttack.new([2], 0), # 4
	BossAttack.new([4], 1), # 5
	BossAttack.new([1, 2], 0), # 6
	BossAttack.new([5], 0), # 7
	BossAttack.new([1, 1, 1], 0), # 8
	BossAttack.new([1], 0), # 9
	BossAttack.new([4, 1, 1], 2), # 10
	BossAttack.new([1, 5], 0), # 11
	BossAttack.new([3, 4], 0), # 12
	BossAttack.new([2], 0), # 13
	BossAttack.new([2, 2, 5], 0), # 14
	BossAttack.new([2, 2, 5], 3), # 15
	BossAttack.new([2, 2, 5], 0), # 16
	BossAttack.new([2, 2, 5], 0), # 17
	BossAttack.new([2, 2, 5], 0), # 18
	BossAttack.new([2, 2, 5], 0), # 19
	BossAttack.new([2, 2, 5], 4), # 20
	BossAttack.new([2, 2, 5], 0), # 21
	BossAttack.new([2, 2, 5], 0), # 22
	BossAttack.new([2, 2, 5], 0), # 23
	BossAttack.new([2, 2, 5], 0), # 24
	BossAttack.new([2, 2, 5], 5), # 25
	BossAttack.new([2, 2, 5], 0), # 26
	BossAttack.new([2, 2, 5], 0), # 27
	BossAttack.new([2, 2, 5], 0), # 28
	BossAttack.new([2, 2, 5], 0), # 29
	BossAttack.new([2, 2, 5], 6), # 30
	BossAttack.new([2, 2, 5], 0), # 31
	BossAttack.new([2, 2, 5], 0), # 32
	BossAttack.new([2, 2, 5], 0), # 33
	BossAttack.new([2, 2, 5], 0), # 34
	BossAttack.new([2, 2, 5], 7), # 35
	BossAttack.new([2, 2, 5], 0), # 36
	BossAttack.new([2, 2, 5], 0), # 37
	BossAttack.new([2, 2, 5], 0), # 38
	BossAttack.new([2, 2, 5], 0), # 39
	BossAttack.new([2, 2, 5], 8), # 40
	BossAttack.new([2, 2, 5], 0), # 41
	BossAttack.new([2, 2, 5], 0), # 42
	BossAttack.new([2, 2, 5], 0), # 43
	BossAttack.new([2, 2, 5], 0), # 44
	BossAttack.new([2, 2, 5], 9), # 45
	BossAttack.new([2, 2, 5], 0), # 46
	BossAttack.new([2, 2, 5], 0), # 47
	BossAttack.new([2, 2, 5], 0), # 48
	BossAttack.new([2, 2, 5], 0), # 49
	BossAttack.new([2, 2, 5], 10), # 50
]

#var attack_array: Array[PackedInt64Array] = [
	#[1],
	#[2],
	#[1, 1],
	#[2],
	#[4],
	#[1, 2],
	#[5],
	#[1, 1, 1],
	#[1],
	#[4, 1, 1],
	#[1, 5],
	#[3, 4],
	#[2],
	#[2, 2, 5],
	#[4, 4, 1],
	#[1, 1, 7],
	#[5],
	#[1, 1, 1, 1, 1, 1, 1, 1, 1],
	#[10],
	#[5, 5, 5],
	#[4],
	#[12, 2, 2],
	#[8, 5],
	#[14],
	#[2],
	#[5, 5, 5, 5, 5],
	#[12],
	#[2, 2, 12, 2],
	#[99999999],
	#[99999999],
	#[99999999],
	#[99999999],
	#[99999999],
	#[99999999],
	#[99999999],
	#[99999999],
	#[99999999],
	#[99999999],
	#[99999999],
	#[99999999]
#]

func next_attack() -> void:
	_attack_ind += 1
	_current_attack.assign(GS.attack_array[_attack_ind])
	_next_attack.assign(GS.attack_array[_attack_ind + 1])
	
	_input_cur.text = str(_current_attack)
	_input_next.text = str(_next_attack)

func get_attack() -> Array[int]:
	return _current_attack

func get_attack_goal() -> int:
	var out = 0
	for i in _current_attack:
		out += i
	return out

func activate_boss_ability(index: int) -> void:
	pass

## Drinking a drink gives all drinks -1 str - HandManager
## Swap charm and strength - Play state
## Draw 1 on drink - Play state
## On drink, slide 1 back - Play state
## End of turn, kill each snakes for drink in hand - Hand Manager
## Swap poison and charm
## Round 5 - Meet this score exactly
## Final: If you don't beat this, redo the round
## 
