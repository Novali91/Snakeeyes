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

var slide_time = 1200
var slide_intro_spacing = 100
var slide_start_offset_pos = 30
var drink_spacing = 125
var margins = Vector2(600,375)

func begin_slide_drinks_in(new_drinks: Array[Drink]) -> void:
	if hm.drinks.size() == 0: #should never be the case but for some reason it is??
		return
	for i in new_drinks.size():
		var drink = new_drinks[i]
		if drink != null:
			drink.slide_start_time = Time.get_ticks_msec() + i * slide_intro_spacing
			drink.slide_location_goal = pick_new_drink_position(drink)
			drink.slide_location_start = Vector2(0,700)
			drink.slide_easing = Drink.easing_function.EASE_OUT
			drink.delete_after_slide = false

func begin_slide_back(drink: Drink) -> void:
	drink.slide_start_time = Time.get_ticks_msec()
	drink.slide_location_start = drink.position
	drink.slide_location_goal = Vector2(-1920,drink.position.y)
	drink.slide_easing = Drink.easing_function.EASE_IN
	drink.delete_after_slide = true

func pick_new_drink_position(drink: Drink) -> Vector2:
	var clear_spot_found = false
	var potential_position = Vector2.ZERO
	var temp_drink_spacing = drink_spacing
	var attempt_count = 0
	while not clear_spot_found:
		potential_position = Vector2(randf_range(margins.x,GS.SCREEN_SIZE.x-margins.x),randf_range(margins.y,GS.SCREEN_SIZE.y-margins.y))
		clear_spot_found = is_drink_position_available(drink, potential_position, temp_drink_spacing)
		attempt_count+=1
		if attempt_count % 10 == 0: #reduce the spacing requirements over time
			temp_drink_spacing*=0.75
	return potential_position

func is_drink_position_available(drink: Drink, potential_position: Vector2, temp_drink_spacing: float) -> bool:
	for other_drink in hm.drinks:
		var dist = potential_position.distance_to(other_drink.slide_location_goal)
		if other_drink != drink and potential_position.distance_to(other_drink.slide_location_goal) < temp_drink_spacing:
			return false
	return true

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
			drink.position = Vector2(drink.slide_location_start.x + amount_through_slide * drink.slide_location_goal.x,drink.slide_location_goal.y)

func finish_slide_drinks() -> void:
	for drink in hm.drinks:
		drink.position = Vector2(drink.slide_location_start.x + drink.slide_location_goal.x,drink.slide_location_goal.y)
		if drink.delete_after_slide:
			hm.remove_drink(drink)
			hm.tooltip_manager.remove_item(drink, true)

func ease_out_0_1(x: float) -> float:
	return sin(clamp(x,0,1) * PI / 2)

func ease_in_0_1(x: float) -> float:
	return sin((clamp(x,0,1) - 1) * PI / 2) + 1
