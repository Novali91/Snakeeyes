class_name AttackManager
extends Node2D

var _attack_ind: int = -1

var _current_attack: Array[int]
var _next_attack: Array[int]

@onready var _input_cur: Label = $Label/InputCur
@onready var _input_next: Label = $Label2/InputNext


func next_attack() -> void:
	_attack_ind += 1
	_current_attack.assign(GS.attack_array[_attack_ind])
	_next_attack.assign(GS.attack_array[_attack_ind + 1])
	
	_input_cur.text = str(_current_attack)
	_input_next.text = str(_next_attack)

func get_attack() -> Array[int]:
	return _current_attack
