class_name PoisonBar
extends Node2D

@onready var _input: Label = $Input
@onready var _liquid: Polygon2D = $Liquid

func _ready() -> void:
	GS.poison_set.connect(set_value)

func set_value(old_val: int, new_val: int) -> void:
	_input.text = str(new_val)
	var mat = _liquid.material as Material
	mat.set_shader_parameter("level",new_val/12.0)
	mat.set_shader_parameter("max_height",_liquid.polygon[3].y)
