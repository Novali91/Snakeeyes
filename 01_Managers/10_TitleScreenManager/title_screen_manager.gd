class_name TitleScreenManager
extends Node2D

signal play_clicked()

@onready var _area: Area2D = $Area2D
@onready var _bubble: Sprite2D = $Bubble
@onready var _collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _text_box: TextBox = $TextBox

var _clicked: bool = false
var _waiting: bool = true

func _ready() -> void:
	_text_box.clicked_close.connect(_text_closed)
	_area.mouse_entered.connect(_mouse_entered)
	_area.mouse_exited.connect(_mouse_exited)
	
	_text_box.open()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("skip_intro"):
		GS.sound_manager.play_confirm()
		play_clicked.emit()
	
	if _clicked or _waiting or GS.in_settings: return
	
	if Input.is_action_just_pressed("click"):
		var dist = get_local_mouse_position().length()
		var radius = _collision_shape.shape.radius
		if dist <= radius:
			_clicked = true
			GS.sound_manager.play_confirm()
			
			_animation_player.play("fade_out")
			await _animation_player.animation_finished
			play_clicked.emit()

func _text_closed() -> void:
	_text_box.close()
	await _text_box.finished_closing
	_animation_player.play("intro")
	await _animation_player.animation_finished
	_waiting = false
	if (_is_mouse_hovering()):
		_mouse_entered()

func _mouse_entered() -> void:
	if _waiting: return
	GS.sound_manager.play_click()
	_bubble.material.set_shader_parameter("alpha", 1)

func _mouse_exited() -> void:
	_bubble.material.set_shader_parameter("alpha", 0)

func _is_mouse_hovering() -> bool:
	return global_position.distance_to(get_global_mouse_position()) <= _collision_shape.shape.radius
