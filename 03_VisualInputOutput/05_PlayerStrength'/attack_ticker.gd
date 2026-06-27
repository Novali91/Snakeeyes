class_name AttackTicker
extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var top_sprite: Texture = preload("res://05_Assets/01_Art/03_UI_Sprites/new REWORKED SUPER SLIM EDITION BEAT ME BOARD.png")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func set_top() -> void:
	sprite.texture = top_sprite

func set_cleared() -> void:
	animation_player.play("clear")

func set_uncleared() -> void:
	animation_player.play("RESET")
