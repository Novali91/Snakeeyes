class_name PlayerStrength
extends Node2D

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

@onready var _input: Label = $Ticker/Input
@onready var _custom_number: CustomNumber = $Ticker/CustomNumber
@onready var _ticker: Sprite2D = $Ticker
@onready var _marker_node = $Markers

var _tween: Tween
var _markers: Array[Marker2D]

func _ready() -> void:
	GS.strength_set.connect(set_value)
	
	for m: Marker2D in _marker_node.get_children():
		_markers.push_back(m)

func set_value(_old_val: int, new_val: int) -> void:
	_input.text = str(new_val)
	
	_custom_number.set_value(new_val)
	
	var clamped = clamp(new_val, 0, 1000)
	var stop_ind: int
	for i in range(1, _TICKER_VALUES.size()):
		stop_ind = i
		if _TICKER_VALUES[i] >= clamped: break
	
	var top_ticker = _TICKER_VALUES[stop_ind]
	var bot_ticker = _TICKER_VALUES[stop_ind - 1]
	
	var top_pos = _markers[stop_ind].position.y
	var bot_pos = _markers[stop_ind - 1].position.y
	
	var percent: float = (clamped - bot_ticker) / float(top_ticker - bot_ticker)
	
	var ticker_target = _TICKER_Y_OFFSET + lerp(bot_pos, top_pos, percent)
	
	if _tween: _tween.kill()
	
	_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(_ticker, "position:y", ticker_target, 1)
	
	if _old_val != new_val && new_val > 0:
		GS.sound_manager.play_bell(new_val)
