class_name CameraManager
extends Node2D

signal done_moving()
signal pass_out_complete()

enum {
	LEFT,
	MIDDLE,
	RIGHT
}

@onready var camera: Camera2D = $Camera2D
@onready var poison_effect: ColorRect = $Camera2D/CanvasLayer/PoisonEffect
@onready var pass_out_effect: ColorRect = $Camera2D/CanvasLayer/PassOutEffect

var _current_ind: int = 1
var _prev_ind: int = 1
var _camera_locked: bool
var _camera_tween: Tween

@export var poison_effect_change_speed: float
@export var poison_fish_eye_intensity: float
@export var poison_effect_begin_level: int
var poison_effect_change_progress: float = -1.0
var old_poison: int = 0
var new_poison: int = 0

@export var pass_out_time: float
@export var pass_out_fall_time: float
var pass_out_started_time: float = -1

func _ready() -> void:
	camera.global_position = Vector2(screen_pos_x(_current_ind), 1080 / 2.)
	GS.poison_set.connect(set_poison_effect)
	pass_out_effect.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		_swipe_left()
	elif Input.is_action_just_pressed("right"):
		_swipe_right()
	if(poison_effect_change_progress >= 0 and poison_effect_change_progress < 1):
		poison_effect_change_progress += _delta * poison_effect_change_speed
		poison_effect.material.set_shader_parameter("fisheye_intensity",clamp((old_poison + (new_poison - old_poison) * poison_effect_change_progress) - poison_effect_begin_level,0,12) * poison_fish_eye_intensity)
	if pass_out_started_time != -1 and Time.get_ticks_msec() > pass_out_started_time + pass_out_time * 1000:
		pass_out_complete.emit()
		pass_out_started_time = -1

func start_pass_out() -> void:
	pass_out_effect.material.set_shader_parameter("start_time",Time.get_ticks_msec()/1000.0)
	pass_out_effect.material.set_shader_parameter("close_time",pass_out_fall_time)
	pass_out_effect.visible = true
	pass_out_started_time = Time.get_ticks_msec()

func set_poison_effect(old_val: int, new_val: int) -> void:
	poison_effect_change_progress = 0.0
	old_poison = old_val
	new_poison = new_val

func smooth_lerp(from: float, to: float, x: float) -> float:
	return from + (to - from) * (sin(PI * (x - 0.5))/2 + 0.5)

func screen_pos_x(ind: int) -> float:
	return (ind + 0.5) * 1920

func switch_screen(screen_ind: int, bypass_lock: bool = false) -> void:
	if _camera_locked and not bypass_lock: return
	if screen_ind == _current_ind:
		done_moving.emit()
		return
	
	_current_ind = screen_ind
	
	if _current_ind == 1:
		new_poison = old_poison
		old_poison = 0
	else:
		old_poison = new_poison
		new_poison = 0
	poison_effect_change_progress = 0
	
	var center = GS.SCREEN_SIZE / 2.
	var target_pos = center + Vector2(GS.SCREEN_SIZE.x * _current_ind, 0)
	
	if _camera_tween: _camera_tween.kill()
	_camera_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
	_camera_tween.tween_property(camera, "global_position", target_pos, 0.5)
	
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
