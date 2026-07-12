class_name DifficultySelectManager
extends Node2D

## 0 for normal, 1 for hard
signal difficulty_selected(difficulty: int)

@onready var _background: Sprite2D = $Background
@onready var _crystal_ball: Sprite2D = $CrystalBall
@onready var _normal: Area2D = $Normal
@onready var _hard: Area2D = $Hard
@onready var _difficulty_ball: Sprite2D = $DifficultyBall
@onready var _ap: AnimationPlayer = $AnimationPlayer

var _clicked: bool = false
var _waiting: bool = true

func _ready() -> void:
	_hard.mouse_entered.connect(_mouse_hovered_hard)
	_hard.area_exited.connect(_mouse_exited_hard)
	_hard.input_event.connect(_hard_clicked)
	_normal.mouse_entered.connect(_mouse_hovered_normal)
	_normal.area_exited.connect(_mouse_exited_normal)
	_normal.input_event.connect(_normal_clicked)

func activate() -> void:
	_background.visible = true
	_crystal_ball.visible = true
	_difficulty_ball.visible = true
	
	_ap.play("fade_in")
	await _ap.animation_finished
	
	_normal.input_pickable = true
	_hard.input_pickable = true
	_waiting = false

func _mouse_hovered_hard() -> void:
	if _waiting:
		return
	GS.sound_manager.play_click()
	## Shader opacity to 1
	pass

func _mouse_exited_hard() -> void:
	if _waiting:
		return
	## Shader opacity to 0
	pass

func _mouse_hovered_normal() -> void:
	if _waiting:
		return
	GS.sound_manager.play_click()
	## Shader opacity to 1
	pass

func _mouse_exited_normal() -> void:
	if _waiting:
		return
	
	## Shader opacity to 0
	pass

func _hard_clicked(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if _clicked or _waiting:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_difficulty_chosen(1)
	pass

func _normal_clicked(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if _clicked or _waiting:
		return
	
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			_difficulty_chosen(0)
	pass

func _difficulty_chosen(difficulty: int) -> void:
	_clicked = true
	GS.sound_manager.play_confirm()
	_crystal_ball.visible = false
	
	_ap.play("fade_out")
	await _ap.animation_finished
	
	difficulty_selected.emit(difficulty)
