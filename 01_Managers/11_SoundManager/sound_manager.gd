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
@onready var game: AudioStreamPlayer = $Music/Game
@onready var menu: AudioStreamPlayer = $Music/Menu
@onready var trap: AudioStreamPlayer = $Music/Trap
@onready var end_turn_bell: AudioStreamPlayer = $EndTurnBell
@onready var typing: AudioStreamPlayer = $Typing
@onready var camera_swoosh: AudioStreamPlayer = $CameraSwoosh
@onready var confirm_click: AudioStreamPlayer = $ConfirmClick
@onready var beat_bell: AudioStreamPlayer = $BeatBell

var _prev_music: AudioStreamPlayer
var _cur_music: AudioStreamPlayer

var jingles: Array[AudioStreamPlayer]

var _bell_base_pitch: float
@export var bell_pitch_step: float

var _transition_progress: float = -1.0
@export var transition_time: float
@export var music_vol: float

func _ready() -> void:
	GS.sound_manager = self
	_bell_base_pitch = bell.pitch_scale
	for child in $Jingles.get_children():
		jingles.append(child as AudioStreamPlayer)

func _process(delta: float) -> void:
	if _transition_progress >= 0.0 and _transition_progress < transition_time:
		_transition_progress = clamp(_transition_progress + delta,0.0,transition_time)
		var prog_proportion = _transition_progress / transition_time
		if _cur_music != null:
			_cur_music.volume_linear = lerp(0.0,music_vol,prog_proportion)
		if _prev_music != null:
			_prev_music.volume_linear = lerp(music_vol,0.0,prog_proportion)
	if _prev_music != null and _prev_music.volume_linear == 0.0:
		_prev_music.stop()

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
	click.play(0.16)

func play_dice() -> void:
	dice.play()
	
func play_fall() -> void:
	fall.play()

func play_slide() -> void:
	slide.play()

func play_end_turn() -> void:
	end_turn_bell.play()

func play_typing() -> void:
	typing.play()

func play_swoosh() -> void:
	camera_swoosh.play()

func play_confirm() -> void:
	confirm_click.play()

func play_beat_bell() -> void:
	beat_bell.play()

func play_jingle(index: int) -> void:
	jingles[index].play()

func play_game() -> void:
	play_music(game)

func play_menu() -> void:
	play_music(menu)

func play_trap() -> void:
	play_music(trap)

func play_music(track: AudioStreamPlayer) -> void:
	_transition_progress = 0.0
	track.play()
	track.volume_linear = 0.0
	_prev_music = _cur_music
	_cur_music = track
