class_name PlayerStrength
extends Node2D

const _TICKER_Y_OFFSET = -210

@onready var _input: Label = $Ticker/Input
@onready var _ticker: Sprite2D = $Ticker

var _tween: Tween

func _ready() -> void:
	GS.strength_set.connect(set_value)

func set_value(old_val: int, new_val: int) -> void:
	_input.text = str(new_val)
	
	var ticker_target = _TICKER_Y_OFFSET - 49 * new_val
	
	if _tween: _tween.kill()
	
	_tween = create_tween().set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
	_tween.tween_property(_ticker, "position:y", ticker_target, 1)
