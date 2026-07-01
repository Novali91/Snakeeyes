class_name OverlayManager
extends Node2D

@onready var retain = $Retain
@onready var buff = $Buff
@onready var kill1 = $Kill
@onready var dbl_poison = $DoublePoison
@onready var dbl_strength = $DoubleStrength
@onready var _slide_back = $SlideBack
@onready var slide_back_1 = $SlideBack1
@onready var slide_back_2 = $SlideBack2
@onready var slide_back_3 = $SlideBack3
@onready var dbl_strength_poison = $DoubleStrengthPoison
@onready var king_kill_1: ColorRect = $KingKill1
@onready var king_kill_2: ColorRect = $KingKill2
@onready var full_deck_kill: ColorRect = $FullDeckKill
@onready var min_deck_warning: ColorRect = $MinDeckWarning

var _cur_overlay: ColorRect

var min_deck_vis: bool = false

func _physics_process(_delta: float) -> void:
	if _cur_overlay != null:
		_cur_overlay.global_position = get_viewport().get_camera_2d().get_screen_center_position() - Vector2(150, 75)
	if min_deck_vis != null:
		min_deck_warning.global_position = get_viewport().get_camera_2d().get_screen_center_position() - Vector2(150, 75)
	return

func toggle_retain(vis) -> void:
	retain.visible = vis
	if vis:
		_cur_overlay = retain
	else:
		_cur_overlay = null

func toggle_buff(vis) -> void:
	buff.visible = vis
	if vis:
		_cur_overlay = buff
	else:
		_cur_overlay = null

func toggle_kill(vis) -> void:
	kill1.visible = vis
	if vis:
		_cur_overlay = kill1
	else:
		_cur_overlay = null

func toggle_dbl_poison(vis) -> void:
	dbl_poison.visible = vis
	if vis:
		_cur_overlay = dbl_poison
	else:
		_cur_overlay = null
	
func toggle_dbl_strength(vis) -> void:
	dbl_strength.visible = vis
	if vis:
		_cur_overlay = dbl_strength
	else:
		_cur_overlay = null

func toggle_slide_back(vis, num) -> void:
	var slide_back
	match num:
		0:
			slide_back = _slide_back
		1:
			slide_back = slide_back_1
		2:
			slide_back = slide_back_2
		3:
			slide_back = slide_back_3
	slide_back.visible = vis
	if vis:
		_cur_overlay = slide_back
	else:
		_cur_overlay = null

func toggle_dbl_strength_poison(vis) -> void:
	dbl_strength_poison.visible = vis
	if vis:
		_cur_overlay = dbl_strength_poison
	else:
		_cur_overlay = null

func toggle_king_kill(vis, num) -> void:
	var king_kill: ColorRect
	match num:
		1: 
			king_kill = king_kill_1
		2:
			king_kill = king_kill_2
	king_kill.visible = vis
	if vis:
		_cur_overlay = king_kill
	else:
		_cur_overlay = null

func toggle_full_deck(vis) -> void:
	full_deck_kill.visible = vis
	if vis:
		_cur_overlay = full_deck_kill
	else:
		_cur_overlay = null

func enable_min_deck_warning() -> void:
	min_deck_vis = true
	min_deck_warning.visible = true
	await get_tree().create_timer(3).timeout
	min_deck_warning.visible = false
	min_deck_vis = false
	
