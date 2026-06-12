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
const STR_PER_ANTI: int = 14
const BETTER_GARDEN_SNAKE: int = 15
const JORMUNGANDR: int = 16
const OUROBOROS: int = 17
const QUETZALCOATL: int = 18
const GORGON_SNAKE: int = 19

func trigger_ability(ind: int, drink_position: Vector2, cur_drink: DrinkResource, og_drink: DrinkResource) -> void:
	match ind:
		NO_ABILITY:
			return
		BLUE_VIPER:
			if sm.hand_manager.get_num_drinks() == 0:
				return
			## Lock camera?
			## Maybe bring up some ui for the selection?
			## Make it so you can't end turn while selecting?
			sm.overlay_manager.toggle_retain(true)
			var chosen_drink: Drink = await pick_drink()
			sm.overlay_manager.toggle_retain(false)
			sm.hand_manager.ability_helper.give_drink_retain(chosen_drink)
		PLACEBOA: 
			draw_cards(1)
		SHORT_TAIL_BOA:
			draw_cards(2)
		LONG_TAIL_BOA:
			draw_cards(3)
		GARDEN_SNAKE: 
			sm.camera_manager.switch_screen(sm.camera_manager.LEFT)
			sm.camera_manager.lock_camera()
			sm.overlay_manager.toggle_buff(true)
			var snake: Snake = await sm.deck_manager.ability_helper.choose_snake()
			sm.overlay_manager.toggle_buff(false)
			sm.deck_manager.ability_helper.upgrade_snake(snake, 1, sm.deck_manager.ability_helper.CHARM)
			sm.camera_manager.switch_screen(sm.camera_manager.MIDDLE, true)
			sm.camera_manager.unlock_camera()
			pass
		CLAIRVOYANT_SNAKE:
			sm.camera_manager.switch_screen(sm.camera_manager.LEFT)
			sm.camera_manager.lock_camera()
			sm.overlay_manager.toggle_dbl_poison(true)
			var snake: Snake = await sm.deck_manager.ability_helper.choose_snake()
			sm.overlay_manager.toggle_dbl_poison(false)
			#sm.camera_manager.unlock_camera()
			sm.camera_manager.switch_screen(sm.camera_manager.MIDDLE) # This logic should be updated when camera manager is updated
			#sm.camera_manager.lock_camera()
			var clairvoyant_drink: Drink = sm.deck_manager.ability_helper.get_clairvoyant_drink(snake)
			play_state.play_card(clairvoyant_drink.attached_drink, drink_position, clairvoyant_drink.attached_drink_resource)
			sm.hand_manager.drinks_drank += 1
			sm.camera_manager.unlock_camera()
		CANNIBAL_SNAKE:
			sm.overlay_manager.toggle_kill(true)
			remove_snake(sm.camera_manager.MIDDLE)
			sm.overlay_manager.toggle_kill(false)
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
			GS.set_antidote_num(GS.get_antidote_num() + 1)
			pass
		STR_PER_ANTI:
			var str_inc: int = GS.get_antidote_num() # Right now it is  str per antidote
			GS.set_strength(GS.get_strength() + str_inc)
		JORMUNGANDR: 
			var total: int = sm.hand_manager.ability_helper.get_total_hand_str()
			GS.set_strength(GS.get_strength() + total)
		OUROBOROS:
			sm.deck_manager.return_to_drawpile(og_drink, cur_drink)
			pass
		QUETZALCOATL:
			draw_cards(3)
			## UI for picking to slideback here:
			var chosen_drink: Drink = await pick_drink()
			quetzalcoatl_slide_back(chosen_drink)
			chosen_drink = await pick_drink()
			quetzalcoatl_slide_back(chosen_drink)
			chosen_drink = await pick_drink()
			quetzalcoatl_slide_back(chosen_drink)
		GORGON_SNAKE:
			var chosen_drink: Drink = await pick_drink()
			chosen_drink.attached_drink.strength = chosen_drink.attached_drink.strength * 2
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

func remove_snake(start_screen: int) -> Vector2i:
	sm.camera_manager.switch_screen(sm.camera_manager.LEFT)
	sm.camera_manager.lock_camera()
	var snake: Snake = await sm.deck_manager.ability_helper.choose_snake()
	var stats: Vector2i = Vector2i(snake.current_drink.strength, snake.current_drink.charm)
	sm.deck_manager.remove_snake(snake)
	sm.camera_manager.switch_screen(start_screen, true)
	sm.camera_manager.unlock_camera()
	return stats

func pick_drink() -> Drink:
	sm.end_turn_button.stop_pressable()
	sm.camera_manager.lock_camera()
	var chosen_drink: Drink = await sm.hand_manager.ability_helper.choose_drink()
	sm.camera_manager.unlock_camera()
	sm.end_turn_button.make_pressable()
	return chosen_drink

func quetzalcoatl_slide_back(drink: Drink) -> void:
	var attached: DrinkResource = drink.attached_drink
	attached.poison -= 1
	attached.strength += 1
	attached.charm += 1
	sm.hand_manager.ability_helper.slide_drink_back(drink)
	sm.deck_manager.return_to_drawpile(drink.attached_drink_resource, drink.attached_drink)
