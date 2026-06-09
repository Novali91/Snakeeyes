class_name DiceManager
extends Node2D

signal number_rolled(val: int)
signal number_accepted(val: int)
signal antidote_used()

@onready var _input: Label = $Label/Input
@onready var _use_antidote_button: Button = $UseAntidoteButton
@onready var _continue_button: Button = $ContinueButton

var _current_value: int

func _ready() -> void:
	visible = false
	
	_use_antidote_button.pressed.connect(_antidote_pressed)
	_continue_button.pressed.connect(_continue_pressed)

func start_roll() -> void:
	visible = true
	_roll()

func close() -> void:
	visible = false

func _roll() -> void:
	var value_rolled = _get_roll_value()
	
	_current_value = value_rolled
	_input.text = str(_current_value)
	number_rolled.emit(_current_value)

func _antidote_pressed() -> void:
	if GS.get_antidote_num() > 0:
		antidote_used.emit()
		GS.set_antidote_num(GS.get_antidote_num() - 1)
		_reroll()

func _reroll() -> void:
	_roll()

func _continue_pressed() -> void:
	number_accepted.emit(_current_value)

func _get_roll_value() -> int:
	return randi_range(1,6) + randi_range(1,6)

func _get_dice_faces(val: int) -> Array[int]:
	var die1 = randi_range(1, val-1)
	var die2 = val - die1
	
	return [die1, die2]
