class_name PlayState
extends TopState

@onready var _ability_helper: AbilityHelper = $AbilityHelper

func setup() -> void:
	sm.end_turn_button.pressed.connect(_end_turn)
	
	_ability_helper.sm = sm

func enter() -> void:
	_draw_cards(5)
	sm.end_turn_button.make_pressable()
	sm.camera_manager.unlock_camera()

func exit() -> void:
	sm.end_turn_button.stop_pressable()

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func _draw_cards(num: int) -> void:
	pass
	# get cards from deck manager
	# check if we need to reshuffle
	# give them to hand manager

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
	sm.switch_state(sm.States.POISON_ROLL)
