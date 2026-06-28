class_name Lady
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var thump: AudioStreamPlayer = $Thump

signal finished()

var _in_wrestle: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and not GS.in_settings and _in_wrestle and GS.tutorial_index != GS.Tutorial.START:
		if animation_player.speed_scale == 1:
			GS.sound_manager.play_swoosh()
		
		animation_player.speed_scale = 6

func win_armwrestle() -> void:
	animation_player.speed_scale = 1
	_in_wrestle = true
	animation_player.play("ArmWrestleStart")
	await animation_player.animation_finished
	thump.play()
	animation_player.play("ArmWrestleWin")
	await animation_player.animation_finished
	finished.emit()
	_in_wrestle = false

func lose_armwrestle(damage: int) -> void:
	animation_player.speed_scale = 1
	_in_wrestle = true
	animation_player.play("ArmWrestleStart")
	await animation_player.animation_finished
	for i in damage:
		thump.play()
		animation_player.play("ArmWrestleDamage")
		await animation_player.animation_finished
		await get_tree().create_timer(0.5).timeout
	finished.emit()
	_in_wrestle = false

func drink_poison() -> void:
	animation_player.play("Drink")
	await animation_player.animation_finished
	finished.emit()

func idle() -> void:
	animation_player.play("Idle")
