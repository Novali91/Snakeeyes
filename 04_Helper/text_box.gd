class_name TextBox
extends Node2D

signal clicked_close()
signal done_typing()
signal finished_closing()

const _PER_CHARACTER_SPEED: float = 0.03
const _WAIT_TIME: float = 0.05
const _SOUND_TIME: float = 0.2

@export var text_array: Array[String]

@onready var _text_label: RichTextLabel = $Text
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _arrow: Sprite2D = $Arrow

var _tween: Tween
var _wait_timer: float = 0
var _text_ind: int = 0
var _waiting: bool = false
var _typing_timer: float = 0
var _opening: bool = true

var _sound_timer: float = 0

func _process(delta: float) -> void:
	if _opening or GS.in_settings: return
	
	if Input.is_action_just_pressed("click"):
		if _waiting:
			if _text_ind >= text_array.size() - 1:
				clicked_close.emit()
			
			else:
				_text_ind += 1
				_reveal_text()
				_waiting = false
				_wait_timer = _WAIT_TIME
		
		else:
			if _wait_timer <= 0:
				_skip_text()
				
				if _text_ind >= text_array.size() - 1:
					done_typing.emit()
	
	if not _waiting and _typing_timer <= 0:
		_waiting = true
		_arrow.visible = true
		
		if _text_ind >= text_array.size() - 1:
			done_typing.emit()
	
	if not _waiting:
		if _sound_timer <= 0:
			_sound_timer += _SOUND_TIME + randf_range(-0.1, 0.1)
			GS.sound_manager.play_typing()
	
	_sound_timer -= delta
	
	_wait_timer -= delta
	_typing_timer -= delta

func update() -> void:
	_text_ind = 0
	_waiting = false
	_reveal_text()

func open() -> void:
	_arrow.visible = false
	_text_ind = 0
	_text_label.text = ""
	_animation_player.play("open")
	await _animation_player.animation_finished
	_opening = false
	_waiting = false
	_reveal_text()

func close() -> void:
	_opening = true
	_animation_player.play("close")
	await _animation_player.animation_finished
	finished_closing.emit()

func set_text_array(arr: Array[String]) -> void:
	text_array = arr
	_text_ind = 0

func _reveal_text() -> void:
	_arrow.visible = false
	
	var text = text_array[_text_ind]
	
	_text_label.visible_ratio = 0
	_text_label.text = text
	
	var time = text.length() * _PER_CHARACTER_SPEED
	
	if _tween: _tween.kill()
	_tween = create_tween()
	_tween.tween_property(_text_label, "visible_ratio", 1.0, time)
	_typing_timer = time

func _skip_text() -> void:
	_tween.kill()
	_waiting = true
	_arrow.visible = true
	_text_label.visible_ratio = 1.0
