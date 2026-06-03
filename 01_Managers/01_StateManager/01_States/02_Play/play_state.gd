class_name PlayState
extends TopState

func setup() -> void:
	sm.end_turn_button.pressed.connect(_end_turn)

func enter() -> void:
	_draw_cards(5)

func exit() -> void:
	pass

func process_tick(_delta: float) -> void:
	pass

func physics_tick(_delta: float) -> void:
	pass

func _draw_cards(num: int) -> void:
	pass
	# get cards from deck manager
	# check if we need to reshuffle
	# give them to hand manager

func _drink(drink: DrinkResource) -> void:
	pass

func _end_turn() -> void:
	sm.switch_state(sm.States.ROLL_DICE)
