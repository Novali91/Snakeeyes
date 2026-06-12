class_name TitleScreenState
extends TopState

func setup() -> void:
	sm.title_screen_manager.play_clicked.connect(_play_clicked)

func enter() -> void:
	sm.camera_manager.lock_camera()

func exit() -> void:
	pass

func _play_clicked() -> void:
	var t = create_tween()
	t.tween_property(sm.title_screen_manager, "modulate:a", 0., 0.5)
	
	await t.finished
	sm.title_screen_manager.queue_free()
	
	sm.switch_state(sm.States.SETUP_TURN)
