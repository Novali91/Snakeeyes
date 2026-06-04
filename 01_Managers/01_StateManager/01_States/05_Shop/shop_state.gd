class_name ShopState
extends TopState

func setup() -> void:
	sm.exit_shop_button.pressed.connect(_exit_shop)

func enter() -> void:
	sm.camera_manager.switch_screen(sm.camera_manager.RIGHT)
	sm.camera_manager.unlock_camera()
	sm.exit_shop_button.make_pressable()
	

func exit() -> void:
	sm.exit_shop_button.stop_pressable()

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func _exit_shop() -> void:
	sm.switch_state(sm.States.END_TURN)
