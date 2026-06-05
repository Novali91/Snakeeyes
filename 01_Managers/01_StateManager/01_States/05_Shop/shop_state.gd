class_name ShopState
extends TopState

func setup() -> void:
	sm.exit_shop_button.pressed.connect(_exit_shop)
	sm.shop_manager.snake_clicked.connect(_check_snake)
	sm.shop_manager.antidote_clicked.connect(_check_antidote)

func enter() -> void:
	sm.camera_manager.switch_screen(sm.camera_manager.RIGHT, true)
	sm.camera_manager.unlock_camera()
	sm.exit_shop_button.make_pressable()
	
	sm.shop_manager.can_buy = true
	

func exit() -> void:
	sm.exit_shop_button.stop_pressable()
	sm.shop_manager.can_buy = false

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func _check_snake(snake: Snake) -> void:
	if snake.attached_snake.cost <= GS.charm:
		GS.charm -= snake.attached_snake.cost
		sm.charm_overlay.spend_charm(snake.attached_snake.cost, snake.global_position)
		
		var snake_copy = sm.shop_manager.create_snake(snake.attached_snake)
		sm.deck_manager.add_snake(snake_copy)
		sm.shop_manager.purchase_snake(snake)

func _check_antidote() -> void:
	if GS.charm >= 3:
		sm.shop_manager.purchase_antidote()
		GS.antidote_num += 1
		GS.charm -= 3
		
		sm.antidote_count.set_value(GS.antidote_num)
		
		sm.charm_overlay.spend_charm(3, sm.shop_manager.antidote_position)

func _exit_shop() -> void:
	sm.switch_state(sm.States.END_TURN)
