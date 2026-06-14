class_name CustomNumber
extends Node2D

const _SPRITE_SIZE: float = 60

@export var digits: int
@export var digit_spacing: float

var _spritesheet: Texture = load("res://05_Assets/01_Art/03_UI_Sprites/numbers spritesheet 60 by 60.png")

var _sprites: Array[Sprite2D] = []

var tint_on: bool = false
var _tint_col: Color = Color.GREEN

func _ready() -> void:
	_init_sprites()

func set_value(val: int) -> void:
	var max_val = pow(10, digits) - 1
	val = clamp(val, 0, max_val)
	
	for i in digits:
		var sprite_ind = digits - i - 1
		var digit_val = val % 10 
		val = floor(val / 10.)
		
		_sprites[sprite_ind].frame = digit_val

func _init_sprites() -> void:
	var inc_offset = _SPRITE_SIZE + digit_spacing
	var start_offset = (digits - 1.0) / 2.0 * inc_offset * -1
	
	for i in digits:
		var new_sprite = _create_sprite()
		new_sprite.position = Vector2(start_offset + inc_offset * i, 0)
		_sprites.push_back(new_sprite)
		add_child(new_sprite)

func _create_sprite() -> Sprite2D:
	var sprite = Sprite2D.new()
	sprite.texture = _spritesheet
	sprite.hframes = 10
	return sprite

func toggle_tint(on: bool) -> void:
	tint_on = on
	if tint_on:
		for sprite in _sprites:
			sprite.modulate = _tint_col
	else:
		for sprite in _sprites:
			sprite.modulate = Color.WHITE
