class_name ShopState
extends TopState

func setup() -> void:
	sm.exit_shop_button.pressed.connect(_exit_shop)
	sm.shop_manager.snake_clicked.connect(_check_snake)
	sm.shop_manager.antidote_clicked.connect(_check_antidote)

func enter() -> void:
	sm.camera_manager.switch_screen(sm.camera_manager.RIGHT)
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
	if snake.attached_snake.cost <= sm.game_stats.charm:
		sm.game_stats.charm -= snake.attached_snake.cost
		sm.charm_overlay.set_value(sm.game_stats.charm)
		
		var snake_copy = sm.shop_manager.create_snake(snake.attached_snake)
		sm.deck_manager.add_snake(snake_copy)
		sm.shop_manager.purchase_snake(snake)

func _check_antidote() -> void:
	if sm.game_stats.charm >= 3:
		sm.shop_manager.purchase_antidote()
		sm.game_stats.antidote_num += 1
		sm.game_stats.charm -= 3
		
		sm.charm_overlay.set_value(sm.game_stats.charm)
		sm.antidote_count.set_value(sm.game_stats.antidote_num)

func _exit_shop() -> void:
	sm.switch_state(sm.States.END_TURN)
