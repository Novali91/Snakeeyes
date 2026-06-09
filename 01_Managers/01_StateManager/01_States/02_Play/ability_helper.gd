class_name AbilityHelper
extends Node

var sm: TopStateMachine
var play_state: PlayState

const NO_ABILITY: int = 0
const BLUE_VIPER: int = 1
const PLACEBOA: int = 2
const SHORT_TAIL_BOA: int = 3
const LONG_TAIL_BOA: int = 4
const GARDEN_SNAKE: int = 5
const CLAIRVOYANT_SNAKE: int = 6
const CANNIBAL_SNAKE: int = 7
const HYDRA: int = 8
const FRIENDLY_SNAKE: int = 9
const FAMILIAR_SNAKE: int = 10
const CHARMING_SNAKE: int = 11
const SNAKE_OF_ASCLEPIUS: int = 12
const KING_COBRA: int = 13

func trigger_ability(ind: int, drink_position: Vector2) -> void:
	match ind:
		NO_ABILITY:
			return
		BLUE_VIPER:
			if sm.hand_manager.get_num_drinks() == 0:
				return
			## Lock camera?
			sm.camera_manager.lock_camera()
			## Maybe bring up some ui for the selection?
			## Make it so you can't end turn while selecting?
			var chosen_drink: Drink = await sm.hand_manager.ability_helper.choose_drink()
			sm.hand_manager.ability_helper.give_drink_retain(chosen_drink)
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
			#sm.camera_manager.unlock_camera()
			sm.camera_manager.switch_screen(sm.camera_manager.MIDDLE) # This logic should be updated when camera manager is updated
			#sm.camera_manager.lock_camera()
			var clairvoyant_drink: DrinkResource = sm.deck_manager.ability_helper.get_clairvoyant_drink(snake)
			play_state.play_card(clairvoyant_drink, drink_position)
			sm.camera_manager.unlock_camera()
		CANNIBAL_SNAKE:
			remove_snake()
			pass
		HYDRA:
			sm.camera_manager.switch_screen(sm.camera_manager.LEFT)
			sm.camera_manager.lock_camera()
			var snake: Snake = await sm.deck_manager.ability_helper.choose_snake()
			snake.num_drinks += 1
			snake.instantiate_tooltip()
			sm.camera_manager.unlock_camera()
			pass
		FRIENDLY_SNAKE:
			sm.hand_manager.ability_helper.change_poison_values_in_hand(1)
			pass
		FAMILIAR_SNAKE:
			## This is where you would roll one D6
			sm.deck_manager.ability_helper.increment_familiar_snakes(4)
			pass
		CHARMING_SNAKE:
			## Maybe some visuals?
			sm.shop_manager.ability_helper.increase_antidote_count(2)
			pass
		SNAKE_OF_ASCLEPIUS:
			## Maybe some visuals?
			GS.antidote_num += 1
			sm.antidote_count.set_value(GS.antidote_num)
			pass
		_:
			return

func draw_cards(num: int) -> void:
	var num_drinks = sm.hand_manager.get_num_drinks()
	var drinks_remaining = GS.HAND_SIZE - num_drinks
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

func remove_snake() -> void:
	sm.camera_manager.switch_screen(sm.camera_manager.LEFT)
	sm.camera_manager.lock_camera()
	var snake: Snake = await sm.deck_manager.ability_helper.choose_snake()
	sm.deck_manager.remove_snake(snake)
	sm.camera_manager.unlock_camera()
