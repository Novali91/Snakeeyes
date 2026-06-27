class_name TopStateMachine
extends Node2D

signal restart()

enum States {
	SETUP_TURN,
	PLAY,
	POISON_ROLL,
	COMPARE_STRENGTH,
	SHOP,
	END_TURN,
	PASS_OUT,
}

var current_state: int

@onready var _state_logic_dict: Dictionary[int, TopState] = {
	States.SETUP_TURN: $States/SetupTurnState,
	States.PLAY: $States/PlayState,
	States.POISON_ROLL: $States/PoisonRollState,
	States.COMPARE_STRENGTH: $States/CompareStrengthState,
	States.SHOP: $States/ShopState,
	States.END_TURN: $States/EndTurnState,
	States.PASS_OUT: $States/PassOutState
}

@onready var _current_state_logic: TopState = _state_logic_dict[current_state]

@onready var score_bar: ScoreBar = %ScoreBar
@onready var charm_overlay: CharmOverlay = %CharmOverlay
@onready var poison_bar: PoisonBar = %PoisonBar
@onready var player_strength: PlayerStrength = %PlayerStrength
@onready var end_turn_button: EndTurnButton = %EndTurnButton

@onready var camera_manager: CameraManager = %CameraManager
@onready var dice_manager: DiceManager = %DiceManager
@onready var attack_manager: AttackManager = %AttackManager
@onready var hand_manager: HandManager = %HandManager
@onready var deck_manager: DeckManager = %DeckManager
@onready var shop_manager: ShopManager = %ShopManager
@onready var ability_helper: AbilityHelper = $AbilityHelper
@onready var overlay_manager: OverlayManager = $OverlayManager
@onready var win_screen: Node2D = $WinScreen
@onready var win_close: Button = $WinScreen/WinClose
@onready var lose_screen: Node2D = $LoseScreen
@onready var lose_close: Button = $LoseScreen/LoseClose
@onready var tutorial_manager: TutorialManager = $TutorialManager
@onready var lady: Lady = $Lady

@onready var refill: AudioStreamPlayer = $Refill
@onready var drink: AudioStreamPlayer = $Drink


func _ready() -> void:
	win_close.pressed.connect(_quit)
	lose_close.pressed.connect(_quit)
	_set_start_values()

func start_game() -> void:
	for state: TopState in _state_logic_dict.values():
		state.sm = self
		state.setup()
	
	ability_helper.sm = self
	shop_manager.ability_helper.top_ability_helper = ability_helper
	ability_helper.play_state = _state_logic_dict[States.PLAY]
	GS.hand_manager = hand_manager
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

func _set_start_values() -> void:
	GS.set_antidote_num(1)
	GS.set_score(3)
	GS.turn_count = 0
	score_bar.set_turn_value(0)
	
	var starting_snakes = shop_manager.get_starting_snakes()
	
	for s: Snake in starting_snakes:
		deck_manager.add_snake(s)

func lose() -> void:
	camera_manager.lock_camera()
	camera_manager.switch_screen(camera_manager.MIDDLE, true)
	lose_screen.visible = true

func win() -> void:
	camera_manager.lock_camera()
	camera_manager.switch_screen(camera_manager.MIDDLE, true)
	win_screen.visible = true

func _quit() -> void:
	get_tree().quit()

func _restart() -> void:
	pass
