class_name ShopState
extends TopState

var _reroll_cost: int = 1

func setup() -> void:
	sm.shop_manager.exit_shop_clicked.connect(_exit_shop)
	sm.shop_manager.snake_clicked.connect(_check_snake)
	sm.shop_manager.antidote_clicked.connect(_check_antidote)
	sm.shop_manager.reroll_clicked.connect(_reroll_pressed)

func enter() -> void:
	_reroll_cost = 1
	sm.shop_manager.update_reroll(_reroll_cost)
	
	sm.camera_manager.switch_screen(sm.camera_manager.RIGHT, true)
	sm.camera_manager.unlock_camera()
	
	sm.shop_manager.toggle_open(true)
	

func exit() -> void:
	sm.shop_manager.toggle_open(false)

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func _check_snake(snake: Snake) -> void:
	if snake.attached_snake.cost <= GS.get_charm():
		GS.set_charm(GS.get_charm() - snake.attached_snake.cost)
		sm.charm_overlay.spend_charm(snake.attached_snake.cost, snake.global_position)
		
		if sm.deck_manager.snake_deck.size() >= 24:
			sm.overlay_manager.toggle_kill(true)
			
			await sm.ability_helper.remove_snake(2)
			
			sm.overlay_manager.toggle_kill(false)
		
		#var snake_copy = sm.shop_manager.create_snake(snake.attached_snake)
		#await sm.shop_manager.ability_helper.buy_snake(snake_copy)
		var snake_copy = sm.shop_manager.create_snake(snake.attached_snake)
		await sm.shop_manager.ability_helper.buy_snake(snake_copy)
		
		sm.deck_manager.add_snake(snake_copy)
		sm.shop_manager.purchase_snake(snake)
		GS.sound_manager.play_jingle(snake.attached_snake.jingle_id)

func _check_antidote() -> void:
	if GS.get_charm() >= GS.ANTIDOTE_COST:
		GS.set_antidote_num(GS.get_antidote_num() + 1)
		GS.set_charm(GS.get_charm() - GS.ANTIDOTE_COST)
		sm.shop_manager.purchase_antidote()
		
		sm.charm_overlay.spend_charm(GS.ANTIDOTE_COST, sm.shop_manager.antidote_position)

func _exit_shop() -> void:
	sm.switch_state(sm.States.END_TURN)

func _reroll_pressed() -> void:
	if GS.get_charm() < _reroll_cost: return
	
	GS.set_charm(GS.get_charm() - _reroll_cost)
	sm.charm_overlay.spend_charm(_reroll_cost, sm.shop_manager.reroll_button.global_position)
	
	sm.camera_manager.lock_camera()
	sm.camera_manager.switch_screen(sm.camera_manager.MIDDLE, true)
	
	_reroll_cost += 1
	sm.shop_manager.update_reroll(_reroll_cost)
	
	sm.shop_manager.empty_shop()
	sm.shop_manager.fill_shop()
	
	await get_tree().create_timer(0.65).timeout
	
	sm.camera_manager.switch_screen(sm.camera_manager.RIGHT, true)
	sm.camera_manager.unlock_camera()
	
