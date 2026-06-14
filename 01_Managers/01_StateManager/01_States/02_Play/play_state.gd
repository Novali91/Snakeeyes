class_name PlayState
extends TopState

func setup() -> void:
	sm.end_turn_button.pressed.connect(_end_turn)
	sm.hand_manager.drink_drank.connect(play_card)

func enter() -> void:
	sm.ability_helper.draw_cards(5)
	sm.hand_manager.drinks_drinkable = true
	sm.end_turn_button.make_pressable()
	sm.camera_manager.unlock_camera()
	sm.score_bar.toggle_flash_goal(false)

func exit() -> void:
	sm.end_turn_button.stop_pressable()

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func play_card(drink: DrinkResource, drink_position: Vector2, og_drink: DrinkResource) -> void:
	GS.set_poison(GS.get_poison() + drink.poison)
	GS.set_strength(GS.get_strength() + drink.strength)
	GS.set_charm(GS.get_charm() + drink.charm)
	
	sm.charm_overlay.gain_charm(drink.charm, drink_position)
	
	sm.ability_helper.trigger_ability(drink.special_ability, drink_position, drink, og_drink)
	
	sm.score_bar.toggle_flash_goal(GS.get_strength() >= sm.attack_manager.get_attack_goal())
	
	if GS.get_poison() >= 12:
		sm.hand_manager.drinks_drinkable = false
		sm.hand_manager.end_turn_discard()
		sm.switch_state(sm.States.PASS_OUT)

func _end_turn() -> void:
	sm.hand_manager.drinks_drinkable = false
	sm.hand_manager.end_turn_discard()
	sm.switch_state(sm.States.POISON_ROLL)
