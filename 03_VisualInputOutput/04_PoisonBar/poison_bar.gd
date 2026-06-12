class_name PoisonBar
extends Node2D

@onready var _input: Label = $Input
@onready var _liquid: ColorRect = $Liquid
var _change_progress: float = -1.0
@export var change_speed: float;
var _old_level: int;
var _new_level: int;

var poison_heights = [0.0,0.0,5.0,10.0,16.67,25.0,39.0,60.0,75.0,85.0,89.0,97.23,100.0]

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
		mat.set_shader_parameter("level",lerp_eased(poison_heights[_old_level],poison_heights[_new_level],_change_progress))
	else:
		_change_progress = -1.0
		mat.set_shader_parameter("level",poison_heights[_new_level])

func lerp_eased(from: float, to: float, x: float) -> float:
	return from + (to-from) * ease_in_out_0_1(x)

func ease_in_out_0_1(x: float) -> float:
	return sin(PI * (x + 0.5))/(-2) + 0.5
