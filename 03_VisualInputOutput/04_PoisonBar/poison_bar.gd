class_name PoisonBar
extends Node2D

@onready var _input: Label = $Input
@onready var _liquid: ColorRect = $Liquid
var _change_progress: float = -1.0
@export var change_speed: float;
var _old_level: int;
var _new_level: int;

func _ready() -> void:
	GS.poison_set.connect(set_value)

func set_value(old_val: int, new_val: int) -> void:
	_input.text = str(new_val)
	_change_progress = 0.0
	_old_level = old_val
	_new_level = new_val

func _process(delta: float) -> void:
	var mat = _liquid.material as Material
	if _change_progress >= 0.0 and _change_progress <= 1.0:
		_change_progress += delta * change_speed
		mat.set_shader_parameter("level",lerp_eased(_old_level,_new_level,_change_progress)/12.0)
	else:
		_change_progress = -1.0
		mat.set_shader_parameter("level",(_new_level)/12.0)

func lerp_eased(from: float, to: float, x: float) -> float:
	return from + (to-from) * ease_in_out_0_1(x)

func ease_in_out_0_1(x: float) -> float:
	return sin(PI * (x + 0.5))/(-2) + 0.5
