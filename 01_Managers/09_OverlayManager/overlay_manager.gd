class_name OverlayManager
extends Node2D

@onready var retain = $Retain
@onready var buff = $Buff
@onready var kill = $Kill
@onready var dbl_poison = $DoublePoison
@onready var dbl_strength = $DoubleStrength
@onready var slide_back_1 = $SlideBack1
@onready var slide_back_2 = $SlideBack2
@onready var slide_back_3 = $SlideBack3
@onready var dbl_strength_poison = $DoubleStrengthPoison

func toggle_retain(vis) -> void:
	retain.visible = vis

func toggle_buff(vis) -> void:
	buff.visible = vis

func toggle_kill(vis) -> void:
	kill.visible = vis

func toggle_dbl_poison(vis) -> void:
	dbl_poison.visible = vis
	
func toggle_dbl_strength(vis) -> void:
	dbl_strength.visible = vis

func toggle_slide_back(vis, num) -> void:
	var slide_back
	match num:
		1:
			slide_back = slide_back_1
		2:
			slide_back = slide_back_2
		3:
			slide_back = slide_back_3
	slide_back.visible = vis

func toggle_dbl_strength_poison(vis) -> void:
	dbl_strength_poison.visible = vis
