class_name PlayerStrength
extends Node2D

@onready var _input: Label = $Input

func _ready() -> void:
	GS.strength_set.connect(set_value)

func set_value(old_val: int, new_val: int) -> void:
	_input.text = str(new_val)
