class_name SlideManager
extends Node

var test_cup = preload('res://02_Deck/01_Drinks/drink.tscn')
var drinks: Array[Drink]

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if drinks != null and drinks.size() > 0:
		var slide_end_time = get_latest_slide_end_time()
		if Time.get_ticks_msec() < slide_end_time:
			slide_drinks()
		elif Time.get_ticks_msec() < slide_end_time + 50: #arbitrarily small amount of ms
			finish_slide_drinks()

func get_latest_slide_end_time() -> float:
	var latest = 0
	for drink in drinks:
		if drink != null and drink.slide_start_time + slide_time > latest:
			latest = drink.slide_start_time + slide_time
	return latest

var temp_cup_height = 150 #temporary placement variable
var slide_time = 1200
var slide_intro_spacing = 100
var slide_start_offset_pos = 30

func begin_slide_drinks(in_drinks: Array[Drink]) -> void:
	drinks = in_drinks
	for i in drinks.size():
		var drink = drinks[i]
		if drink != null:
			drink.slide_start_time = Time.get_ticks_msec() + i * slide_intro_spacing
			drink.slide_location_goal = get_drink_spacing(i,drinks.size())

func get_drink_spacing(i: int, num_cups: int) -> float:
	return ((i+1) / float(num_cups+1)) * 1920

func slide_drinks() -> void:
	for i in drinks.size():
		var drink = drinks[i]
		var amount_through_slide_linear = (Time.get_ticks_msec() - drink.slide_start_time - slide_start_offset_pos)/float(slide_time)
		var amount_through_slide = clamp(ease_out_0_1(amount_through_slide_linear),-slide_start_offset_pos,1)
		if drink != null:
			drink.position = Vector2(amount_through_slide * drink.slide_location_goal,1080 - temp_cup_height)

func finish_slide_drinks() -> void:
	for i in drinks.size():
		var drink = drinks[i]
		if drink != null:
			drink.position = Vector2(drink.slide_location_goal,1080 - temp_cup_height)

func ease_out_0_1(x: float) -> float:
	return sin(clamp(x,0,1) * PI / 2)
