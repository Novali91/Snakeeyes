class_name ScoreBar
extends Node2D

@onready var _input: Label = $Input

func set_value(val: int) -> void:
	_input.text = str(val)
