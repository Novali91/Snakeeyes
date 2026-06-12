class_name SlideManager
extends Node

signal delete_after_slide(drink: Drink)

const _FAR_TABLE_SCALE: float = 0.8
const _CLOSE_TABLE_SCALE: float = 1.2
const _TABLE_DIM: Vector2 = Vector2(1, 0.45)
const _LOCAL_DIM: Vector2 = Vector2(1920, 380)
const _WAIT_TIME: float = 0.25
const _SLIDE_TIME: float = 1.2
const _X_OFF_SCREEN: float = -60

const _ENDPOINT_MAX_TABLE_OFFSET: float = 0.0

var _all_endpoints: Array[Vector2]
var _empty_endpoints: Array[Vector2]

var _active_drinks: Array[Drink]

func _ready() -> void:
	_populate_endpoints()

func _process(delta: float) -> void:
	_update_slide(delta)

func slide_drinks(drinks: Array[Drink]) -> void:
	for d: Drink in drinks:
		_empty_endpoints.shuffle()
		var endpoint = _empty_endpoints.pop_front()
		var offset_dir = Vector2.RIGHT.rotated(randf_range(0, TAU))
		var offset = offset_dir * randf_range(0, _ENDPOINT_MAX_TABLE_OFFSET)
		var offset_endpoint = endpoint + offset
		
		var local_endpoint = _to_local(offset_endpoint)
		
		d.position = Vector2(_X_OFF_SCREEN, local_endpoint.y)
		
		d.slide_start = d.position
		d.slide_target = local_endpoint
		d.slide_easing = d.EASE_OUT
		d.delete_after_slide = false
		d.scale = Vector2.ONE * _get_scale(endpoint.y)
		
		var ind = _all_endpoints.find(endpoint)
		d.slide_ind = ind
	
	for d: Drink in drinks:
		if d == null: continue
		
		d.visible = true
		
		_active_drinks.push_back(d)
		
		await get_tree().create_timer(_WAIT_TIME).timeout

func slide_back(drink: Drink) -> void:
	drink.slide_start = drink.position
	drink.slide_target = Vector2(_X_OFF_SCREEN, drink.position.y)
	drink.slide_easing = drink.EASE_IN
	drink.delete_after_slide = true
	
	if drink not in _active_drinks:
		_active_drinks.push_back(drink)

func free_endpoint(drink: Drink) -> void:
	if drink in _active_drinks:
		_active_drinks.erase(drink)
	
	_empty_endpoints.push_back(_all_endpoints[drink.slide_ind])

func _populate_endpoints() -> void:
	_all_endpoints = [
		Vector2(0.1, 0.3),
		Vector2(0.2, 0.3),
		Vector2(0.3, 0.3),
		Vector2(0.4, 0.3),
		Vector2(0.5, 0.3),
		Vector2(0.6, 0.3),
		Vector2(0.7, 0.3),
		Vector2(0.8, 0.3),
	]
	
	_empty_endpoints = _all_endpoints.duplicate()

func _update_slide(delta: float) -> void:
	for d in _active_drinks:
		
		d.slide_time += delta
		
		var anim_percent = d.slide_time / _SLIDE_TIME
		anim_percent = clampf(anim_percent, 0, 1)
		
		if d.slide_easing == d.EASE_IN:
			anim_percent = _ease_in_0_1(anim_percent)
		
		elif d.slide_easing == d.EASE_OUT:
			anim_percent = _ease_out_0_1(anim_percent)
		
		d.position = lerp(d.slide_start, d.slide_target, anim_percent)
		
		if anim_percent == 1:
			_active_drinks.erase(d)
			
			if d.delete_after_slide:
				delete_after_slide.emit(d)

func _to_table(pos: Vector2) -> Vector2:
	var y_offset = GS.SCREEN_SIZE.y - _LOCAL_DIM.y
	return (pos - Vector2(0, y_offset)) / _LOCAL_DIM * _TABLE_DIM

func _to_local(pos: Vector2) -> Vector2:
	var y_offset = GS.SCREEN_SIZE.y - _LOCAL_DIM.y
	return pos / _TABLE_DIM * _LOCAL_DIM + Vector2(0, y_offset)

func _get_scale(table_y: float) -> float:
	var factor = table_y / _TABLE_DIM.y
	return lerp(_FAR_TABLE_SCALE, _CLOSE_TABLE_SCALE, factor)

func _ease_out_0_1(x: float) -> float:
	return sin(clamp(x,0,1) * PI / 2)

func _ease_in_0_1(x: float) -> float:
	return sin((clamp(x,0,1) - 1) * PI / 2) + 1
