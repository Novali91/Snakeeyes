class_name PoisonBar
extends Node2D

@onready var input: Label = $Input

func set_value(val: int) -> void:
	input.text = str(val)
