class_name PlayState
extends TopState

@onready var _ability_helper: AbilityHelper = $AbilityHelper

func setup() -> void:
	sm.end_turn_button.pressed.connect(_end_turn)
	sm.hand_manager.drink_clicked.connect(_play_card)
	_ability_helper.sm = sm

func enter() -> void:
	draw_cards(5)
	sm.end_turn_button.make_pressable()
	sm.camera_manager.unlock_camera()

func exit() -> void:
	sm.end_turn_button.stop_pressable()

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func draw_cards(num: int) -> void:
	print("drawing cards")
	var num_drinks = sm.hand_manager.get_num_drinks()
	var drinks_remaining = sm.game_stats.HAND_SIZE - num_drinks
	var real_draw = min(num, drinks_remaining)
	
	var draw_remaining = real_draw
	while draw_remaining:
		print("draw rem: "+str(draw_remaining))
		var drinks = sm.deck_manager.draw(draw_remaining)
		draw_remaining -= drinks.size()
		
		# hand manager slides drinks
		sm.hand_manager.draw_drinks(drinks)
		
		if draw_remaining > 0:
			print("shuffling")
			_reshuffle_draw_pile()
		
		await get_tree().create_timer(0.1).timeout

func _reshuffle_draw_pile() -> void:
	sm.deck_manager.reshuffle_drawpile()

func _play_card(drink: DrinkResource) -> void:
	var new_poison = sm.game_stats.poison + drink.poison
	new_poison = max(1, new_poison)
	
	sm.game_stats.poison = new_poison
	sm.game_stats.strength += drink.strength
	sm.game_stats.charm += drink.charm
	
	sm.poison_bar.set_value(sm.game_stats.poison)
	sm.player_strength.set_value(sm.game_stats.strength)
	sm.charm_overlay.set_value(sm.game_stats.charm)
	
	_ability_helper.trigger_ability(drink.special_ability)
	
	if sm.game_stats.poison >= 12:
		sm.switch_state(sm.States.PASS_OUT)

func _end_turn() -> void:
	sm.hand_manager.end_turn_discard()
	sm.switch_state(sm.States.POISON_ROLL)
