class_name AntidoteCount
extends Node2D

@onready var custom_number: CustomNumber = $CustomNumber

func _ready() -> void:
	GS.antidote_num_set.connect(set_value)

func set_value(old_val: int, new_val: int) -> void:
	custom_number.set_value(new_val)
