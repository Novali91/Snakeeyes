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

var current_state: int

@onready var _state_logic_dict: Dictionary[int, TopState] = {
	States.SETUP_TURN: $States/SetupTurnState,
	States.PLAY: $States/PlayState,
	States.ROLL_DICE: $States/RollDiceState,
	States.COMPARE_STRENGTH: $States/CompareStrengthState,
	States.SHOP: $States/ShopState,
	States.PASS_OUT: $States/PassOutState
}

@onready var _current_state_logic: TopState = _state_logic_dict[current_state]

@onready var score_bar: ScoreBar = %ScoreBar
@onready var charm_overlay: CharmOverlay = %CharmOverlay
@onready var poison_bar: PoisonBar = %PoisonBar
@onready var player_strength: PlayerStrength = %PlayerStrength
@onready var antidote_count: AntidoteCount = %AntidoteCount
@onready var end_turn_button: EndTurnButton = %EndTurnButton
@onready var exit_shop_button: ExitShopButton = %ExitShopButton

@onready var game_stats: GameStats = $GameStats
@onready var camera_manager: CameraManager = %CameraManager

func _ready() -> void:
	for state: TopState in _state_logic_dict.values():
		state.sm = self
		state.setup()
	
	switch_state(States.SETUP_TURN)

func _process(delta: float) -> void:
	_current_state_logic.process_tick(delta)

func _physics_process(delta: float) -> void:
	_current_state_logic.physics_tick(delta)

func switch_state(new_state: int) -> void:
	if _current_state_logic:
		_current_state_logic.exit()
	
	current_state = new_state
	_current_state_logic = _state_logic_dict[current_state]
	_current_state_logic.enter()
