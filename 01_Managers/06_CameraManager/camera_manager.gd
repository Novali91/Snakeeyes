class_name CameraManager
extends Node2D

signal done_moving()

enum {
	LEFT,
	MIDDLE,
	RIGHT
}

@onready var camera: Camera2D = $Camera2D

var _current_ind: int = 1
var _camera_locked: bool

func _ready() -> void:
	camera.global_position = Vector2(1920 * 1.5, 1080 / 2.)

func _process(_delta: float) -> void:
	if _camera_locked: return
	
	if Input.is_action_just_pressed("left"):
		_swipe_left()
	
	elif Input.is_action_just_pressed("right"):
		_swipe_right()

func switch_screen(screen_ind: int) -> void:
	if screen_ind == _current_ind:
		done_moving.emit()
		return
	
	_current_ind = screen_ind
	camera.global_position.x = (_current_ind + 0.5) * 1920
	done_moving.emit()

func lock_camera() -> void:
	_camera_locked = true

func unlock_camera() -> void:
	_camera_locked = false

func _swipe_left() -> void:
	var new_ind = _current_ind - 1
	if new_ind >= 0:
		switch_screen(new_ind)

func _swipe_right() -> void:
	var new_ind = _current_ind + 1
	if new_ind < 3:
		switch_screen(new_ind)
