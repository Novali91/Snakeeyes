class_name SlideManager
extends Node

@onready var hm: HandManager = get_parent()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	if hm.drinks != null and hm.drinks.size() > 0:
		var slide_end_time = get_latest_slide_end_time()
		if Time.get_ticks_msec() < slide_end_time:
			slide_drinks()
		elif Time.get_ticks_msec() < slide_end_time + 50: #arbitrarily small amount of ms
			finish_slide_drinks()

func get_latest_slide_end_time() -> float:
	var latest = 0
	for drink in hm.drinks:
		if drink != null and drink.slide_start_time + slide_time > latest:
			latest = drink.slide_start_time + slide_time
	return latest

var temp_cup_height = 300 #temporary placement variable
var slide_time = 1200
var slide_intro_spacing = 100
var slide_start_offset_pos = 30

func begin_slide_drinks_in(new_drinks: Array[Drink]) -> void:
	if hm.drinks.size() == 0: #should never be the case but for some reason it is??
		return
	var drinks_size_before_change = hm.drinks.size() - new_drinks.size()
	for i in new_drinks.size():
		var drink = new_drinks[i]
		if drink != null:
			drink.slide_start_time = Time.get_ticks_msec() + i * slide_intro_spacing
			drink.slide_location_goal = pick_new_drink_position((i+drinks_size_before_change),hm.drinks.size())
			drink.slide_location_start = Vector2(0,700)
			drink.slide_easing = Drink.easing_function.EASE_OUT
			drink.delete_after_slide = false

func begin_slide_back(drink: Drink) -> void:
	drink.slide_start_time = Time.get_ticks_msec()
	drink.slide_location_start = drink.position
	drink.slide_location_goal = Vector2(-1920,700)
	drink.slide_easing = Drink.easing_function.EASE_IN
	drink.delete_after_slide = true

func pick_new_drink_position(i: int, num_cups: int) -> Vector2:
	return Vector2(((i+1) / float(num_cups+1)) * 1920,700)

func slide_drinks() -> void:
	for i in hm.drinks.size():
		var drink = hm.drinks[i]
		var amount_through_slide_linear = (Time.get_ticks_msec() - drink.slide_start_time - slide_start_offset_pos)/float(slide_time)
		var amount_through_slide: float
		if drink.slide_easing == Drink.easing_function.EASE_OUT:
			amount_through_slide = clamp(ease_out_0_1(amount_through_slide_linear),-slide_start_offset_pos,1)
		if drink.slide_easing == Drink.easing_function.EASE_IN:
			amount_through_slide = clamp(ease_in_0_1(amount_through_slide_linear),-slide_start_offset_pos,1)
		if drink != null:
			drink.position = Vector2(drink.slide_location_start.x + amount_through_slide * drink.slide_location_goal.x,1080 - temp_cup_height)

func finish_slide_drinks() -> void:
	for drink in hm.drinks:
		drink.position = Vector2(drink.slide_location_start.x + drink.slide_location_goal.x,1080 - temp_cup_height)
		if drink.delete_after_slide:
			hm.remove_drink(drink)
			hm.tooltip_manager.remove_item(drink, true)

func ease_out_0_1(x: float) -> float:
	return sin(clamp(x,0,1) * PI / 2)

func ease_in_0_1(x: float) -> float:
	return sin((clamp(x,0,1) - 1) * PI / 2) + 1
