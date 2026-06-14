class_name DiceManager
extends CanvasLayer

signal number_rolled(val: int)
signal number_accepted(val: int)
signal antidote_used()
signal closed()

@onready var _p_res: Label = $PoisonRes
@onready var _p_res_input: Label = $PoisonRes/Input
@onready var _p_lvl: Label = $PoisonLevel
@onready var _p_lvl_input: Label = $PoisonLevel/Input
@onready var _bonus: Label = $Bonus
@onready var _use_antidote_button: Button = $UseAntidoteButton
@onready var _continue_button: Button = $ContinueButton
@onready var _dice1: AnimatedSprite2D = $Dice1
@onready var _dice2: AnimatedSprite2D = $Dice2
@onready var _cup: AnimatedSprite2D = $Cup
@onready var _cup_loc: Marker2D = $CupLoc
@onready var _label_loc: Marker2D = $LabelLoc

var _animation_progress = -1.0
@export var animation_time: float
@export var cup_lower_time: float
@export var text_appear_time: float
@export var bonus_appear_time: float
@export var cup_shake_frequency: float
@export var cup_shake_wavelength: float
@export var cup_shake_offset: float

var _current_value: int

var num_scarlets: int

var poison: int
var show_poison: bool

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	visible = false
	_use_antidote_button.pressed.connect(_antidote_pressed)
	_continue_button.pressed.connect(_continue_pressed)

func _process(delta: float) -> void:
	if _animation_progress >= 0 and _animation_progress < animation_time:
		_animation_progress += delta
		if _animation_progress > cup_lower_time:
			if _animation_progress < cup_lower_time + 0.05:
				GS.sound_manager.play_dice()
			elif _animation_progress < text_appear_time:
				_cup.position.x = _cup_loc.position.x + (sin((_animation_progress + cup_shake_offset) * cup_shake_frequency))/(_animation_progress+cup_shake_offset)*cup_shake_wavelength
			elif _animation_progress < bonus_appear_time:
				_cup.frame = 1
				_dice1.visible = true
				_dice2.visible = true
				_p_res.visible = true
				_p_res_input.visible = true
				if show_poison:
					_p_lvl.visible = true
					_p_lvl_input.visible = true
				_p_res.position.y = _label_loc.position.y + 1080 - 1080 * _ease_out_0_1((_animation_progress-text_appear_time)/(bonus_appear_time-text_appear_time))
				_p_lvl.position.y = _p_res.position.y
			else:
				_p_res_input.text = str(_current_value)
				_bonus.visible = true
				_bonus.position.y = _label_loc.position.y + 100 - 30 * _ease_out_0_1((_animation_progress-bonus_appear_time)/(animation_time-bonus_appear_time))
				_continue_button.visible = true
				_use_antidote_button.visible = true
				if show_poison and _current_value <= poison:
					#show antidote button in red somehow
					pass
	else:
		_bonus.visible = false
	_cup.position.y = _cup_loc.position.y - 1080 + _ease_out_0_1(_animation_progress/cup_lower_time) * 1080

func set_poison(p: int) -> void:
	poison = p
	_p_lvl_input.text = str(poison)

func _ease_out_0_1(x: float) -> float:
	return sin(clamp(x,0,1) * PI / 2)

func start_roll(lower_cup: bool, show_p: bool) -> void:
	visible = true
	_animation_player.play("open")
	
	show_poison = show_p
	if lower_cup:
		_animation_progress = 0.0
	else:
		_animation_progress = cup_lower_time
	_cup.frame = 0
	_cup.position.x = _cup_loc.position.x
	_dice1.visible = false
	_dice2.visible = false
	_p_res.visible = false
	_p_res_input.visible = false
	_p_lvl.visible = false
	_p_lvl_input.visible = false
	_continue_button.visible = false
	_use_antidote_button.visible = false
	_roll()

func close() -> void:
	_animation_player.play("close")
	await _animation_player.animation_finished
	visible = false
	closed.emit()

func _roll() -> void:
	var d1val = randi_range(1,6)
	var d2val = randi_range(1,6)
	var value_rolled = d1val + d2val
	
	_current_value = value_rolled + num_scarlets
	_p_res_input.text = str(_current_value - num_scarlets)
	if num_scarlets == 0:
		_bonus.text = ""
	else:
		_bonus.text = "+" + str(num_scarlets)
	number_rolled.emit(_current_value)
	_dice1.frame = d1val-1
	_dice2.frame = d2val-1

func _antidote_pressed() -> void:
	if GS.get_antidote_num() > 0:
		antidote_used.emit()
		GS.set_antidote_num(GS.get_antidote_num() - 1)
		_reroll()

func _reroll() -> void:
	start_roll(false,show_poison)

func _continue_pressed() -> void:
	number_accepted.emit(_current_value)

func _get_dice_faces(val: int) -> Array[int]:
	var die1 = randi_range(1, val-1)
	var die2 = val - die1
	
	return [die1, die2]
