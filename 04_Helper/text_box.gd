class_name TextBox
extends Node2D

const _PER_CHARACTER_SPEED: float = 0.01
const _WAIT_TIME: float = 0.1

var text_array: Array[String]

@onready var _text_label: RichTextLabel = $ColorRect/Text
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var _tween: Tween
var _wait_timer: float = 0
var _text_ind: int = 0
var _waiting: bool = false

func _ready() -> void:
	_animation_player.play("open")
	await _animation_player.animation_finished
	_reveal_text()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if _waiting:
			_reveal_text()
			_text_ind += 1
			_waiting = false
			_wait_timer = _WAIT_TIME
			
			if _text_ind >= text_array.size():
				pass
				# remove
		
		else:
			if _wait_timer <= 0:
				_skip_text()
		
		_wait_timer += delta

func _reveal_text() -> void:
	var text = text_array[_text_ind]
	
	_text_label.visible_ratio = 0
	_text_label.text = text
	
	var time = text.length() * _PER_CHARACTER_SPEED
	
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.tween_property(_text_label, "visible_characters", 1.0, time)

func _skip_text() -> void:
	_waiting = true
	_text_label.visible_ratio = 1.0
