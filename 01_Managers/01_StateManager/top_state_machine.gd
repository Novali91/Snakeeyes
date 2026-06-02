class_name TopStateMachine
extends Node

enum States {
	SETUP_TURN,
	PLAY,
	ROLL_DICE,
	COMPARE_STRENGTH,
	SHOP,
	PASS_OUT,
}

var current_state: int = States.SETUP_TURN

@onready var _state_logic_dict: Dictionary[int, TopState] = {
	States.SETUP_TURN: $SetupTurnState,
	States.PLAY: $PlayState,
	States.ROLL_DICE: $RollDiceState,
	States.COMPARE_STRENGTH: $CompareStrengthState,
	States.SHOP: $ShopState,
	States.PASS_OUT: $PassOutState
}

@onready var _current_state_logic: TopState = _state_logic_dict[current_state]

func _ready() -> void:
	for state: TopState in _state_logic_dict.values():
		state.state_machine = self

func _process(delta: float) -> void:
	_current_state_logic.process_tick(delta)

func _physics_process(delta: float) -> void:
	_current_state_logic.physics_tick(delta)

func switch_state(new_state: int) -> void:
	_current_state_logic.exit()
	current_state = new_state
	_current_state_logic = _state_logic_dict[current_state]
	_current_state_logic.enter()
