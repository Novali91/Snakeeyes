class_name AttackManager
extends Node2D

var _attack_ind: int = -1
var _attack_arr: Array[PackedInt64Array] = [
	[1],
	[2],
	[1, 1],
	[2],
	[3]
]

var _current_attack: Array[int]
var _next_attack: Array[int]

@onready var _input_cur: Label = $Label/InputCur
@onready var _input_next: Label = $Label2/InputNext


func next_attack() -> void:
	_attack_ind += 1
	_current_attack.assign(_attack_arr[_attack_ind])
	_next_attack.assign(_attack_arr[_attack_ind + 1])
	
	_input_cur.text = str(_current_attack)
	_input_next.text = str(_next_attack)

func get_attack() -> Array[int]:
	return _current_attack
