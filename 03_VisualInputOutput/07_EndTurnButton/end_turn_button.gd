class_name EndTurnButton
extends Node2D

signal pressed()

var _pressable: bool = false

@onready var _button: Button = $Button

func _ready() -> void:
	_button.pressed.connect(_button_pressed)

func _button_pressed() -> void:
	if _pressable:
		pressed.emit()

func make_pressable() -> void:
	_pressable = true

func stop_pressable() -> void:
	_pressable = false
