class_name SoundManager
extends Node2D

@onready var clink: AudioStreamPlayer = $Clink
@onready var gulp: AudioStreamPlayer = $Gulp
@onready var charm: AudioStreamPlayer = $Charm

func _ready() -> void:
	GS.sound_manager = self

func play_clink() -> void:
	clink.play(0.2)
	
func play_gulp() -> void:
	gulp.play()

func play_charm() -> void:
	charm.play()
