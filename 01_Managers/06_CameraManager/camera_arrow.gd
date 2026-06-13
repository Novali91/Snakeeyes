class_name CameraArrow
extends Button

signal arrow_pressed(left_pointing: bool)

@export var is_pointing_left: bool = false

func _ready() -> void:
	mouse_entered.connect(_start_hover)
	mouse_exited.connect(_end_hover)
	button_up.connect(_button_pressed)

func _start_hover() -> void:
	pass

func _end_hover() -> void:
	pass

func _button_pressed() -> void:
	arrow_pressed.emit(is_pointing_left)
