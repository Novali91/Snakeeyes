class_name PlayerStrength
extends Node2D

const _ATTACK_TICKER_SCENE = preload("res://03_VisualInputOutput/05_PlayerStrength'/attack_ticker.tscn")
const _NEXT_ATTACK_TICKER_SCENE = preload("res://03_VisualInputOutput/05_PlayerStrength'/next_attack_ticker.tscn")
const _TICKER_Y_OFFSET = -200
const _TICKER_VALUES = [
	0,
	1,
	2,
	3,
	4,
	5,
	10,
	15,
	20,
	30,
	40,
	50,
	60,
	80,
	120,
	1000
]

@onready var _custom_number: CustomNumber = $Ticker/CustomNumber
@onready var _ticker: Sprite2D = $Ticker
@onready var _marker_node = $Markers

var _tween: Tween
var _markers: Array[Marker2D]

var _attack_tickers: Array[Node2D] = []
var _next_attack_tickers: Array[Node2D] = []

func _ready() -> void:
	GS.strength_set.connect(set_value)
	
	for m: Marker2D in _marker_node.get_children():
		_markers.push_back(m)

func place_attack_tickers(attacks: Array[int], next_attacks: Array[int]) -> void:
	for attack_ticker in _attack_tickers:
		attack_ticker.queue_free()
	
	for next_attack_ticker in _next_attack_tickers:
		next_attack_ticker.queue_free()
	
	_attack_tickers = []
	_next_attack_tickers = []
	
	var attack_total = 0
	for attack in attacks:
		attack_total += attack
		var temp_attack_ticker = _ATTACK_TICKER_SCENE.instantiate()
		add_child(temp_attack_ticker)
		temp_attack_ticker.get_child(1).set_value(attack_total)
		temp_attack_ticker.position.y = get_height(attack_total) - _TICKER_Y_OFFSET
		_attack_tickers.append(temp_attack_ticker)
	
	_attack_tickers[-1].set_top()
	
	attack_total = 0
	for next_attack in next_attacks:
		attack_total += next_attack
		var temp_next_attack_ticker = _NEXT_ATTACK_TICKER_SCENE.instantiate()
		add_child(temp_next_attack_ticker)
		temp_next_attack_ticker.get_child(1).set_value(attack_total)
		temp_next_attack_ticker.position.y = get_height(attack_total) - _TICKER_Y_OFFSET
		temp_next_attack_ticker.get_child(1).tint_col = Color.from_rgba8(30,30,30,255)
		temp_next_attack_ticker.get_child(1).toggle_tint(true)
		_next_attack_tickers.append(temp_next_attack_ticker)
	
	_next_attack_tickers[-1].set_top()
	

func get_height(val: int) -> float:
	var stop_ind: int
	for i in range(1, _TICKER_VALUES.size()):
		stop_ind = i
		if _TICKER_VALUES[i] >= val: break
	
	var top_ticker = _TICKER_VALUES[stop_ind]
	var bot_ticker = _TICKER_VALUES[stop_ind - 1]
	
	var top_pos = _markers[stop_ind].position.y
	var bot_pos = _markers[stop_ind - 1].position.y
	
	var percent: float = (val - bot_ticker) / float(top_ticker - bot_ticker)
	
	return _TICKER_Y_OFFSET + lerp(bot_pos, top_pos, percent)

func set_value(_old_val: int, new_val: int) -> void:
	_custom_number.set_value(new_val)
	
	var clamped = clamp(new_val, 0, 1000)
	var ticker_target = get_height(clamped)
	
	if _tween: _tween.kill()
	
	_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(_ticker, "position:y", ticker_target, 1)
	
	for attack_ticker in _attack_tickers:
		attack_ticker.get_child(1).toggle_tint(ticker_target <= attack_ticker.position.y + _TICKER_Y_OFFSET)
	
	if _old_val != new_val && new_val > 0:
		GS.sound_manager.play_bell(new_val)
