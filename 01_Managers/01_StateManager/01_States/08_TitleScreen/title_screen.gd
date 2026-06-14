class_name TitleScreenState
extends TopState

func setup() -> void:
	sm.title_screen_manager.play_clicked.connect(_play_clicked)

func enter() -> void:
	sm.camera_manager.lock_camera()
	GS.sound_manager.play_menu()

func exit() -> void:
	pass

func _play_clicked() -> void:
	sm.title_screen_manager.queue_free()
	GS.sound_manager.play_game()
	sm.switch_state(sm.States.SETUP_TURN)
