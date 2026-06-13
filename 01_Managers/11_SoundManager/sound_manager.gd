class_name SoundManager
extends Node2D

@onready var clink: AudioStreamPlayer = $Clink
@onready var gulp: AudioStreamPlayer = $Gulp
@onready var charm: AudioStreamPlayer = $Charm
@onready var bell: AudioStreamPlayer = $Bell
@onready var click: AudioStreamPlayer = $Click
@onready var dice: AudioStreamPlayer = $Dice
@onready var fall: AudioStreamPlayer = $Fall
@onready var slide: AudioStreamPlayer = $Slide

var _bell_base_pitch: float
@export var bell_pitch_step: float

func _ready() -> void:
	GS.sound_manager = self
	_bell_base_pitch = bell.pitch_scale

func play_clink() -> void:
	clink.play(0.2)
	
func play_gulp() -> void:
	gulp.play()

func play_charm() -> void:
	charm.play()

func play_bell(level: int) -> void:
	bell.pitch_scale = _bell_base_pitch + level * bell_pitch_step
	bell.play()

func play_click() -> void:
	click.play()

func play_dice() -> void:
	dice.play()
	
func play_fall() -> void:
	fall.play()

func play_slide() -> void:
	slide.play()
