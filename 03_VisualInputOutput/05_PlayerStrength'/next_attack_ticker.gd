extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
@onready var top_sprite: Texture = preload("res://05_Assets/01_Art/03_UI_Sprites/new REWORKED SUPER SLIM EDITION BEAT ME BOARD.png")

func set_top() -> void:
	sprite.texture = top_sprite
