class_name CameraManager
extends Node2D

signal done_moving()

@onready var camera: Camera2D = $Camera2D

var _current_ind: int = 1

func _ready() -> void:
	camera.global_position = Vector2(1280 * 1.5, 720 / 2.)

func move_screen(screen_ind: int) -> void:
	if screen_ind == _current_ind:
		done_moving.emit()
		return
	
	_current_ind = screen_ind
	camera.global_position.x = (_current_ind + 0.5) * 1280
	done_moving.emit()

func swipe_left() -> void:
	var new_ind = _current_ind - 1
	if new_ind >= 0:
		move_screen(new_ind)

func swipe_right() -> void:
	var new_ind = _current_ind + 1
	if new_ind < 3:
		move_screen(new_ind)
