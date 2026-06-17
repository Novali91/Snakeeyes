class_name TopRoot
extends Node

@onready var _title_screen_manager: TitleScreenManager = $TitleScreenManager

var _state_machine_scene: PackedScene = preload("res://01_Managers/01_StateManager/top_state_machine.tscn")
var _sm: TopStateMachine

func _ready() -> void:
	_spawn_sm()
	GS.sound_manager.play_menu()
	await _title_screen_manager.play_clicked
	_title_screen_manager.queue_free()
	GS.sound_manager.play_game()
	_sm.start_game()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("end_turn"):
		_restart()

func _restart() -> void:
	_sm.queue_free()
	_spawn_sm()
	_sm.start_game()

func _spawn_sm() -> void:
	_sm = _state_machine_scene.instantiate()
	_sm.restart.connect(_restart)
	add_child(_sm)
