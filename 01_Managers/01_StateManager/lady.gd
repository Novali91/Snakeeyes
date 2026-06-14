class_name Lady
extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var thump: AudioStreamPlayer = $Thump

signal finished()

func win_armwrestle() -> void:
	animation_player.play("ArmWrestleStart")
	await animation_player.animation_finished
	animation_player.play("ArmWrestleWin")
	await animation_player.animation_finished
	finished.emit()

func lose_armwrestle(damage: int) -> void:
	animation_player.play("ArmWrestleStart")
	await animation_player.animation_finished
	for i in damage:
		thump.play()
		animation_player.play("ArmWrestleDamage")
		await animation_player.animation_finished
		await get_tree().create_timer(0.5).timeout
	finished.emit()

func drink_poison() -> void:
	animation_player.play("Drink")
	await animation_player.animation_finished
	finished.emit()

func idle() -> void:
	animation_player.play("Idle")
