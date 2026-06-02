extends Node2D

var test_cup = preload('res://02_Deck/01_Drinks/drink.tscn')
var cups: Array[Node2D] = []
var cup_location_goals = []
var slide_start_time = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var slide_end_time = slide_start_time + slide_time
	if Time.get_ticks_msec() < slide_end_time:
		slide_cups()
	elif Time.get_ticks_msec() < slide_end_time + 5:
		finish_slide_cups()

var temp_cup_height = 150 #temporary placement variable
var slide_time = 600

func begin_slide_cups(drinks: Array[DrinkResource]) -> void:
	slide_start_time = Time.get_ticks_msec()
	for i in drinks.size():
		var drink = drinks[i]
		var new_cup = test_cup.instantiate()
		cups.append(new_cup)
		#somehow link cup to the drink data structure here
		#or maybe just store it for later when theyre clicked
		add_child(new_cup)
		cup_location_goals.append(get_cup_spacing(i,drinks.size()))

func get_cup_spacing(i: int, num_cups: int) -> float:
	return ((i+1) / float(num_cups+1)) * get_parent().SCREEN_SIZE.x

func slide_cups() -> void:
	for i in cups.size():
		cups[i].global_position = Vector2(global_position.x + ((Time.get_ticks_msec() - slide_start_time)/float(slide_time)) * cup_location_goals[i],global_position.y + get_parent().SCREEN_SIZE.y - temp_cup_height) #Will change this get_parent call later, screen size will prob be made global somehow

func finish_slide_cups() -> void:
	for i in cups.size():
		cups[i].global_position = Vector2(global_position.x + cup_location_goals[i],global_position.y + get_parent().SCREEN_SIZE.y - temp_cup_height)
