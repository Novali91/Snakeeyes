class_name TopRoot
extends Node

@onready var _title_screen_manager: TitleScreenManager = $TitleScreenManager
@onready var settings: CanvasLayer = $Settings
@onready var restart_button: Button = $Settings/RestartButton
@onready var quit_button: Button = $Settings/QuitButton
@onready var vol_slider: HSlider = $Settings/VolSlider

var _state_machine_scene: PackedScene = preload("res://01_Managers/01_StateManager/top_state_machine.tscn")
var _sm: TopStateMachine

var _in_menu: bool = true

func _ready() -> void:
	vol_slider.value = AudioServer.get_bus_volume_linear(0)
	
	restart_button.pressed.connect(_restart)
	quit_button.pressed.connect(_quit)
	vol_slider.value_changed.connect(_volume_bar_changed)
	
	_spawn_sm()
	GS.sound_manager.play_menu()
	await _title_screen_manager.play_clicked
	_title_screen_manager.queue_free()
	_in_menu = false
	GS.sound_manager.play_game()
	_sm.start_game()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("settings"):
		if GS.in_settings:
			settings.visible = false
		
		else:
			settings.visible = true
		
		GS.in_settings = not GS.in_settings
	
	if Input.is_action_just_pressed("restart"):
		_restart()

func _restart() -> void:
	if _in_menu: return
	
	_sm.queue_free()
	_spawn_sm()
	_sm.start_game()
	GS.sound_manager.play_game()

func _quit() -> void:
	get_tree().quit()

func _spawn_sm() -> void:
	_sm = _state_machine_scene.instantiate()
	_sm.restart.connect(_restart)
	add_child(_sm)

func _volume_bar_changed(new_val: float) -> void:
	AudioServer.set_bus_volume_linear(0, new_val)
