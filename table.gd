extends Node2D

var test_cup = preload('res://test_cup.tscn')
var cups: Array[Node2D] = []

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

var temp_cup_height = 300 #temporary placement variable
func slide_cups(drinks: Array[Drink]) -> void:
	for i in drinks.size():
		var drink = drinks[i]
		var new_cup = test_cup.instantiate()
		cups.append(new_cup)
		#somehow link cup to the drink data structure here
		add_child(new_cup)
		new_cup.global_position = Vector2(get_cup_spacing(i,drinks.size()),global_position.y + get_parent().SCREEN_SIZE.y - temp_cup_height) #Will change this get_parent call later, screen size will prob be made global somehow

func get_cup_spacing(i: int, num_cups: int) -> float:
	return global_position.x + (i / float(num_cups)) * get_parent().SCREEN_SIZE.x
