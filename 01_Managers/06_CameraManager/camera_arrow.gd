class_name CameraArrow
extends Button

signal arrow_pressed(left_pointing: bool)

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var is_pointing_left: bool = false

func _ready() -> void:
	mouse_entered.connect(_start_hover)
	mouse_exited.connect(_end_hover)
	button_up.connect(_button_pressed)

func _start_hover() -> void:
	sprite_2d.material.set_shader_parameter("alpha", 1.0)

func _end_hover() -> void:
	sprite_2d.material.set_shader_parameter("alpha", 0.0)

func _button_pressed() -> void:
	arrow_pressed.emit(is_pointing_left)
