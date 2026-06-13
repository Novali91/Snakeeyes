class_name OverlayManager
extends Node2D

@onready var retain = $Retain
@onready var buff = $Buff
@onready var kill = $Kill
@onready var dbl_poison = $DoublePoison
@onready var retain_strength = $RetainStrength

func toggle_retain(vis) -> void:
	retain.visible = vis

func toggle_buff(vis) -> void:
	buff.visible = vis

func toggle_kill(vis) -> void:
	kill.visible = vis

func toggle_dbl_poison(vis) -> void:
	dbl_poison.visible = vis
	
func toggle_retain_strength(vis) -> void:
	retain_strength.visible = vis
