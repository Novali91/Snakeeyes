class_name HandManager
extends Node2D

var test_cup = preload('res://02_Deck/01_Drinks/drink.tscn')
var cups: Array[Node2D] = []
var cup_location_goals = []
var slide_start_times = [0]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	var slide_end_time = slide_start_times[slide_start_times.size()-1] + slide_time 
	if Time.get_ticks_msec() < slide_end_time:
		slide_cups()
	elif Time.get_ticks_msec() < slide_end_time + 50: #arbitrarily small amount of ms
		finish_slide_cups()

var temp_cup_height = 150 #temporary placement variable
var slide_time = 1200
var slide_intro_spacing = 100
var slide_start_offset_pos = 30

func begin_slide_cups(drinks: Array[DrinkResource]) -> void:
	slide_start_times = []
	for i in drinks.size():
		slide_start_times.append(Time.get_ticks_msec() + i * slide_intro_spacing)
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
		var amount_through_slide_linear = (Time.get_ticks_msec() - slide_start_times[i] - slide_start_offset_pos)/float(slide_time)
		var amount_through_slide = clamp(ease_out_0_1(amount_through_slide_linear),-slide_start_offset_pos,1)
		cups[i].global_position = Vector2(global_position.x + amount_through_slide * cup_location_goals[i],global_position.y + get_parent().SCREEN_SIZE.y - temp_cup_height) #Will change this get_parent call later, screen size will prob be made global somehow

func finish_slide_cups() -> void:
	for i in cups.size():
		cups[i].global_position = Vector2(global_position.x + cup_location_goals[i],global_position.y + get_parent().SCREEN_SIZE.y - temp_cup_height)

func ease_out_0_1(x: float) -> float:
	return sin(clamp(x,0,1) * PI / 2)
