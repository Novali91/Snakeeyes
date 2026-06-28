class_name ScoreBar
extends Node2D

@onready var turn: CustomNumber = $Turn
@onready var total_turns: CustomNumber = $TotalTurns
@onready var lives: Node2D = $Lives

func _ready() -> void:
	GS.score_set.connect(set_score_value)
	
	total_turns.set_value(36)

func set_score_value(_old_val: int, new_val: int) -> void:
	for i in 6:
		lives.get_children()[i].frame = 0 if i < new_val else 1

func set_turn_value(val: int) -> void:
	turn.set_value(val)
