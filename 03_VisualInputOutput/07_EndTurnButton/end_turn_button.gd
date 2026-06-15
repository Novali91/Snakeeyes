class_name EndTurnButton
extends Node2D

signal pressed()

var _pressable: bool = false

@onready var _button: Button = $Button
@onready var sprite: Sprite2D = $Sprite2D
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_button.pressed.connect(_button_pressed)
	_button.mouse_entered.connect(_button_hover)
	_button.mouse_exited.connect(_button_unhover)
	
	sprite.material.set_shader_parameter("color", Color(1.0, 0.37, 0.507, 1.0))

func _button_pressed() -> void:
	if _pressable:
		pressed.emit()
		_animation_player.play("press")

func _button_hover() -> void:
	sprite.material.set_shader_parameter("color", Color(1.0, 0.685, 0.37, 1.0))

func _button_unhover() -> void:
	sprite.material.set_shader_parameter("color", Color(1.0, 0.37, 0.507, 1.0))

func make_pressable() -> void:
	_pressable = true

func stop_pressable() -> void:
	_pressable = false
