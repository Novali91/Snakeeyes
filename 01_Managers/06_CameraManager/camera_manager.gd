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
var _prev_ind: int = 1
var _camera_locked: bool
var _transition_progress: float = -1
var transition_total_time: float = 0.75

func _ready() -> void:
	camera.global_position = Vector2(screen_pos_x(_current_ind), 1080 / 2.)

func _process(_delta: float) -> void:
	if _camera_locked: return
	
	#if camera is mid-transition
	if _transition_progress > -1 && _transition_progress < transition_total_time:
		_transition_progress += _delta
		camera.global_position.x = smooth_lerp(screen_pos_x(_prev_ind), screen_pos_x(_current_ind), _transition_progress/transition_total_time)
	else:
		if Input.is_action_just_pressed("left"):
			_swipe_left()
		elif Input.is_action_just_pressed("right"):
			_swipe_right()

func smooth_lerp(from: float, to: float, x: float) -> float:
	return from + (to - from) * (sin(PI * (x - 0.5))/2 + 0.5)

func screen_pos_x(ind: int) -> float:
	return (ind + 0.5) * 1920

func switch_screen(screen_ind: int) -> void:
	if screen_ind == _current_ind:
		done_moving.emit()
		return
	
	_current_ind = screen_ind
	
	_transition_progress = 0
	done_moving.emit()

func lock_camera() -> void:
	_camera_locked = true

func unlock_camera() -> void:
	_camera_locked = false

func _swipe_left() -> void:
	_prev_ind = _current_ind
	var new_ind = _current_ind - 1
	if new_ind >= 0:
		switch_screen(new_ind)

func _swipe_right() -> void:
	_prev_ind = _current_ind
	var new_ind = _current_ind + 1
	if new_ind < 3:
		switch_screen(new_ind)
