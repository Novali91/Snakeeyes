class_name EndTurnButton
extends Node2D

signal pressed()

@onready var button: Button = $Button

func _ready() -> void:
	button.pressed.connect(_button_pressed)

func _button_pressed() -> void:
	pressed.emit()
