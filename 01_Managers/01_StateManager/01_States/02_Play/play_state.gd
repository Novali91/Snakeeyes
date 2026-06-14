class_name PlayState
extends TopState

## Drinking a drink gives all drinks -1 str - HandManager - 2
## Swap charm and strength - Play state - 3
## Draw 1 on drink - Play state - 4
## On drink, slide 1 back - Play state - 5
## End of turn, kill each snakes for drink in hand - Hand Manager - 6
## Swap poison and charm - 7
## Round 5 - Meet this score exactly - 1
## Final: If you don't beat this, redo the round - 10
## On drink, give its snake +1 poison - 8
## All dice rolls -1

const EXACT_SCORE: int = 1 # X
const DRINK_ALL_DRINKS_MINUS_STR: int = 2 # X
const SWAP_CHARM_STR: int = 3 # X
const DRINK_DRAW_ONE: int = 4 # X
const DRINK_SLIDE_BACK: int = 5 # X
const END_KILL_SNAKES: int = 6 # X
const SWAP_POISON_CHARM: int = 7 # X
const DRINK_SNAKE_ONE_POISON: int = 8  # X
const DICE_ROLLS_MINUS_ONE: int = 9 # X
const WIN_ROUND: int = 10 # X

func setup() -> void:
	sm.end_turn_button.pressed.connect(_end_turn)
	sm.hand_manager.drink_drank.connect(play_card)

func enter() -> void:
	if GS.in_tutorial:
		await get_tree().create_timer(1.0).timeout
		sm.camera_manager.switch_screen(sm.camera_manager.LEFT, true) 
		
		# refill animation
		await get_tree().create_timer(5.0).timeout
		
		sm.camera_manager.switch_screen(sm.camera_manager.MIDDLE, true) 
		
		await get_tree().create_timer(2.0).timeout
	
	sm.ability_helper.draw_cards(5)
	
	sm.hand_manager.drinks_drinkable = true
	sm.end_turn_button.make_pressable()
	sm.camera_manager.unlock_camera()
	
	if GS.cur_attack_index == DICE_ROLLS_MINUS_ONE:
		sm.dice_manager.num_scarlets -= 1

func exit() -> void:
	sm.end_turn_button.stop_pressable()

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func play_card(drink: DrinkResource, drink_position: Vector2, og_drink: DrinkResource) -> void:
	match GS.cur_attack_index:
		SWAP_CHARM_STR:
			GS.set_poison(GS.get_poison() + drink.poison)
			GS.set_strength(GS.get_strength() + drink.charm)
			GS.set_charm(GS.get_charm() + drink.strength)
			sm.charm_overlay.gain_charm(drink.strength, drink_position)
		
		SWAP_POISON_CHARM:
			GS.set_poison(GS.get_poison() + drink.charm)
			GS.set_strength(GS.get_strength() + drink.strength)
			GS.set_charm(GS.get_charm() + drink.poison)
			sm.charm_overlay.gain_charm(drink.poison, drink_position)
		
		_:
			GS.set_poison(GS.get_poison() + drink.poison)
			GS.set_strength(GS.get_strength() + drink.strength)
			GS.set_charm(GS.get_charm() + drink.charm)
			sm.charm_overlay.gain_charm(drink.charm, drink_position)
	
	if GS.get_poison() >= 12:
		sm.hand_manager.drinks_drinkable = false
		sm.hand_manager.end_turn_discard()
		sm.switch_state(sm.States.PASS_OUT)
		return
	
	match GS.cur_attack_index:
		DRINK_ALL_DRINKS_MINUS_STR:
			sm.hand_manager.ability_helper.change_str_values_in_hand(-1)
			
		DRINK_DRAW_ONE:
			sm.ability_helper.draw_cards(1)
			
		DRINK_SLIDE_BACK:
			sm.overlay_manager.toggle_slide_back(true, 1)
			
			var drink_to_slide: Drink = await sm.ability_helper.pick_drink()
			sm.hand_manager.ability_helper.slide_drink_back(drink_to_slide)
			sm.deck_manager.return_to_drawpile(drink_to_slide.attached_drink_resource, drink_to_slide.attached_drink)
			
			sm.overlay_manager.toggle_slide_back(false, 1)
		
		DRINK_SNAKE_ONE_POISON:
			if drink.parent_snake != null:
				drink.parent_snake.current_drink.poison += 1
		
		
		_:
			pass
	
	sm.ability_helper.trigger_ability(drink.special_ability, drink_position, drink, og_drink)
	
	sm.score_bar.toggle_flash_goal(GS.get_strength() >= sm.attack_manager.get_attack_goal())

func _end_turn() -> void:
	sm.hand_manager.drinks_drinkable = false
	if GS.cur_attack_index == END_KILL_SNAKES:
		sm.camera_manager.lock_camera()
		sm.camera_manager.switch_screen(sm.camera_manager.LEFT, true)
		for drink: Drink in sm.hand_manager.drinks:
			if drink.attached_drink.parent_snake != null:
				sm.deck_manager.remove_snake(drink.attached_drink.parent_snake)
		await get_tree().create_timer(1).timeout
	sm.hand_manager.end_turn_discard()
	sm.switch_state(sm.States.POISON_ROLL)
