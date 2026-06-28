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
@onready var _anti_sprite: Sprite2D = $UseAntidoteButton/Sprite2D
@onready var _cont_sprite: Sprite2D = $ContinueButton/Sprite2D
@onready var _flash_player: AnimationPlayer = $FlashPlayer

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

var roll_is_for_poison: bool

var antidote_pressable: bool = true

var _has_picked_flash_anim: bool = false

var speed_up: bool = false

var _speed_timer: float = 0

#
#var antidote_flash_progress: float = 0.0
#@export var antidote_flash_time: float
#var antidote_flashing: bool = false

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var _tutorial_has_rerolled: bool = false
var in_tutorial: bool = false

func _ready() -> void:
	visible = false
	_use_antidote_button.pressed.connect(_antidote_pressed)
	_continue_button.pressed.connect(_continue_pressed)
	_use_antidote_button.mouse_entered.connect(_antidote_hovered)
	_use_antidote_button.mouse_exited.connect(_antidote_unhovered)
	_continue_button.mouse_entered.connect(_continue_hovered)
	_continue_button.mouse_exited.connect(_continue_unhovered)

func _process(delta: float) -> void:
	if visible and _speed_timer <= 0.0 and not speed_up and Input.is_action_just_pressed("click") \
			 and GS.tutorial_index in [GS.Tutorial.NONE, GS.Tutorial.SKIPPED] and not GS.in_settings:
		speed_up = true
	
	_speed_timer -= delta
	
	#antidote_flash_progress += delta
	#if antidote_flashing and antidote_flash_progress > antidote_flash_time:
		#antidote_flash_progress = 0.0
		#if _use_antidote_button.modulate == Color.RED:
			#_use_antidote_button.modulate = Color.WHITE
		#else:
			#_use_antidote_button.modulate = Color.RED
	if _animation_progress >= 0 and _animation_progress < animation_time:
		if speed_up:
			_animation_progress += delta * 3
		else:
			_animation_progress += delta
		
		if _animation_progress > cup_lower_time:
			if _animation_progress < cup_lower_time + 0.05:
				GS.sound_manager.play_dice()
			elif _animation_progress < text_appear_time:
				_cup.position.x = _cup_loc.position.x + (sin((_animation_progress + cup_shake_offset) * cup_shake_frequency))/(_animation_progress+cup_shake_offset)*cup_shake_wavelength
			elif _animation_progress < bonus_appear_time:
				number_rolled.emit(_current_value)
				_cup.frame = 1
				_dice1.visible = true
				_dice2.visible = true
				_p_res.visible = true
				_p_res_input.visible = true
				_p_lvl.visible = true
				_p_lvl_input.visible = true
				_p_res.position.y = _label_loc.position.y + 1080 - 1080 * _ease_out_0_1((_animation_progress-text_appear_time)/(bonus_appear_time-text_appear_time))
				_p_lvl.position.y = _p_res.position.y
			else:
				_p_res_input.text = str(_current_value)
				_bonus.visible = true
				_bonus.position.y = _label_loc.position.y + 100 - 30 * _ease_out_0_1((_animation_progress-bonus_appear_time)/(animation_time-bonus_appear_time))
				_use_antidote_button.visible = true
				_continue_button.visible = true
				if not _has_picked_flash_anim:
					_has_picked_flash_anim = true
					if _current_value >= poison:
						_flash_player.play("RESET")
						_flash_player.play("should_continue")
					else:
						_flash_player.play("RESET")
						_flash_player.play("need_antidote")
				
				#_continue_button.visible = true
				#_use_antidote_button.modulate = Color.WHITE
				#antidote_flashing = false
				#if _current_value >= poison:
					#_use_antidote_button.visible = false
				#else:
					#_use_antidote_button.visible = true
					#antidote_flashing = true
					#_use_antidote_button.modulate = Color.RED
	else:
		_bonus.visible = false
	_cup.position.y = _cup_loc.position.y - 1080 + _ease_out_0_1(_animation_progress/cup_lower_time) * 1080

func set_poison(p: int) -> void:
	poison = p
	_p_lvl_input.text = str(poison)

func _ease_out_0_1(x: float) -> float:
	return sin(clamp(x,0,1) * PI / 2)

func roll_the_dice(is_poison: bool) -> void:
	visible = true
	_animation_player.play("open")
	#await _animation_player.animation_finished
	start_roll(is_poison, is_poison)

func start_roll(lower_cup: bool, is_poison: bool) -> void:
	speed_up = false
	_speed_timer = 0.1
	
	_has_picked_flash_anim = false
	visible = true
	roll_is_for_poison = is_poison
	if !roll_is_for_poison:
		set_poison(7)
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
	
	if GS.tutorial_index == GS.Tutorial.START and not _tutorial_has_rerolled:
		d1val = 1
		d2val = 1
		_tutorial_has_rerolled = true
	elif GS.tutorial_index == GS.Tutorial.START and _tutorial_has_rerolled:
		d1val = 2
		d2val = 4
		_tutorial_has_rerolled = false
	elif GS.tutorial_index == GS.Tutorial.NEXT_TURN and not _tutorial_has_rerolled:
		d1val = 6
		d2val = 2
		_tutorial_has_rerolled = true
	
	var value_rolled = d1val + d2val
	
	_current_value = value_rolled + num_scarlets
	_p_res_input.text = str(_current_value - num_scarlets)
	if num_scarlets == 0:
		_bonus.text = ""
	else:
		if num_scarlets > 0:
			_bonus.text = "+" + str(num_scarlets)
		else:
			_bonus.text = str(num_scarlets)
	
	_dice1.frame = d1val-1
	_dice2.frame = d2val-1

func _antidote_pressed() -> void:
	if GS.get_antidote_num() > 0 and antidote_pressable:
		antidote_used.emit()
		GS.set_antidote_num(GS.get_antidote_num() - 1)
		_reroll()

func _reroll() -> void:
	start_roll(false,roll_is_for_poison)

func _continue_pressed() -> void:
	if in_tutorial: return
	number_accepted.emit(_current_value)

func _antidote_hovered() -> void:
	_anti_sprite.material.set_shader_parameter("alpha", 1.0)

func _antidote_unhovered() -> void:
	_anti_sprite.material.set_shader_parameter("alpha", 0.0)

func _continue_hovered() -> void:
	if in_tutorial: return
	_cont_sprite.material.set_shader_parameter("alpha", 1.0)

func _continue_unhovered() -> void:
	_cont_sprite.material.set_shader_parameter("alpha", 0.0)
