class_name AntidoteCount
extends Node2D

@onready var input: Label = $Input

func set_health(val: int) -> void:
	input.text = str(val)
