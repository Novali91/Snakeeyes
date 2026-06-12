class_name ScoreBar
extends Node2D

@onready var _score: CustomNumber = $Score
@onready var _goal: CustomNumber = $Goal
@onready var _turn: CustomNumber = $Turn

func _ready() -> void:
	GS.score_set.connect(set_score_value)

func set_score_value(_old_val: int, new_val: int) -> void:
	_score.set_value(new_val)

func set_turn_value(val: int) -> void:
	_turn.set_value(val)

func set_goal_value(val: int) -> void:
	_goal.set_value(val)
