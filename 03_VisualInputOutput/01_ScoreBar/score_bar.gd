class_name ScoreBar
extends Node2D

@onready var _score: CustomNumber = $Score
@onready var _goal: CustomNumber = $Goal
@onready var _turn: CustomNumber = $Turn

var _flash_goal_prog = -1.0
const FLASH_GOAL_TIME: float = 0.25

func _ready() -> void:
	GS.score_set.connect(set_score_value)

func _process(delta: float) -> void:
	if _flash_goal_prog >= 0.0:
		_flash_goal_prog += delta
		if _flash_goal_prog > FLASH_GOAL_TIME:
			_flash_goal_prog = 0.0
			_goal.toggle_tint(!_goal.tint_on)

func set_score_value(_old_val: int, new_val: int) -> void:
	_score.set_value(new_val)

func set_turn_value(val: int) -> void:
	_turn.set_value(val)

func set_goal_value(val: int) -> void:
	_goal.set_value(val)

func toggle_flash_goal(on: bool) -> void:
	if on:
		_flash_goal_prog = 0.0
	else:
		_flash_goal_prog = -1.0
