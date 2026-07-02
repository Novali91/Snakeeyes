class_name ScoreBar
extends Node2D

@onready var turn: CustomNumber = $Turn
@onready var total_turns: CustomNumber = $TotalTurns
@onready var lives: Node2D = $Lives
@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	GS.score_set.connect(set_score_value)
	
	total_turns.set_value(36)
	
	GS.attack_hovered.connect(boss_hovered)
	GS.attack_unhovered.connect(boss_unhovered)

func set_score_value(_old_val: int, new_val: int) -> void:
	for i in 6:
		lives.get_children()[i].frame = 0 if i < new_val else 1

func set_turn_value(val: int) -> void:
	turn.set_value(val)

func boss_hovered() -> void:
	sprite.material.set_shader_parameter("alpha", 1.0)

func boss_unhovered() -> void:
	sprite.material.set_shader_parameter("alpha", 0.0)
