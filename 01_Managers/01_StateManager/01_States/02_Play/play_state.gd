class_name PlayState
extends TopState

@onready var _ability_helper: AbilityHelper = $AbilityHelper

func setup() -> void:
	sm.end_turn_button.pressed.connect(_end_turn)
	sm.hand_manager.drink_drank.connect(play_card)
	_ability_helper.sm = sm
	_ability_helper.play_state = self

func enter() -> void:
	_ability_helper.draw_cards(5)
	sm.end_turn_button.make_pressable()
	sm.camera_manager.unlock_camera()

func exit() -> void:
	sm.end_turn_button.stop_pressable()

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func play_card(drink: DrinkResource, drink_position: Vector2) -> void:

	var new_poison = GS.poison + drink.poison
	new_poison = max(1, new_poison)
	
	GS.poison = new_poison
	GS.strength += drink.strength
	GS.charm += drink.charm
	
	sm.poison_bar.set_value(GS.poison)
	sm.player_strength.set_value(GS.strength)
	
	sm.charm_overlay.gain_charm(drink.charm, drink_position)
	
	_ability_helper.trigger_ability(drink.special_ability, drink_position)
	
	if GS.poison >= 12:
		sm.switch_state(sm.States.PASS_OUT)

func _end_turn() -> void:
	sm.hand_manager.end_turn_discard()
	sm.switch_state(sm.States.POISON_ROLL)
