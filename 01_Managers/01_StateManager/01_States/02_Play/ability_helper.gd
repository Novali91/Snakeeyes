class_name AbilityHelper
extends Node

var sm: TopStateMachine

const NO_ABILITY: int = 0
const BLUE_VIPER: int = 1
const PLACEBOA: int = 2
const SHORT_TAIL_BOA: int = 3
const LONG_TAIL_BOA: int = 4
const GARDEN_SNAKE: int = 5
const CLAIRVOYANT_SNAKE: int = 6

func trigger_ability(ind: int) -> void:
	match ind:
		NO_ABILITY:
			return
		BLUE_VIPER:
			## Lock camera?
			sm.camera_manager.lock_camera()
			## Maybe bring up some ui for the selection?
			## Make it so you can't end turn while selecting?
			var chosen_drink: Drink = await sm.hand_manager.ability_helper.choose_drink()
			sm.deck_manager.return_to_drawpile(chosen_drink)
			sm.hand_manager.ability_helper.slide_drink_back(chosen_drink)
			sm.camera_manager.unlock_camera()
		PLACEBOA: 
			draw_cards(1)
		SHORT_TAIL_BOA:
			draw_cards(2)
		LONG_TAIL_BOA:
			draw_cards(3)
		GARDEN_SNAKE: 
			sm.camera_manager.switch_screen(sm.camera_manager.LEFT)
			sm.camera_manager.lock_camera()
			var snake: Snake = await sm.deck_manager.ability_helper.choose_snake()
			sm.deck_manager.ability_helper.upgrade_snake(snake, 1, sm.deck_manager.ability_helper.STRENGTH)
			sm.camera_manager.unlock_camera()
			pass
		CLAIRVOYANT_SNAKE:
			sm.camera_manager.switch_screen(sm.camera_manager.LEFT)
			sm.camera_manager.lock_camera()
			var snake: Snake = await sm.deck_manager.ability_helper.choose_snake()
			sm.deck_manager.ability_helper.upgrade_snake(snake, 1, sm.deck_manager.ability_helper.STRENGTH)
			sm.camera_manager.unlock_camera()
		pass

func draw_cards(num: int) -> void:
	var num_drinks = sm.hand_manager.get_num_drinks()
	var drinks_remaining = sm.game_stats.HAND_SIZE - num_drinks
	var real_draw = min(num, drinks_remaining)
	
	var draw_remaining = real_draw
	while draw_remaining:
		var drinks = sm.deck_manager.draw(draw_remaining)
		draw_remaining -= drinks.size()
		
		sm.hand_manager.draw_drinks(drinks)
		
		if draw_remaining > 0:
			_reshuffle_draw_pile()

func _reshuffle_draw_pile() -> void:
	sm.deck_manager.reshuffle_drawpile()
