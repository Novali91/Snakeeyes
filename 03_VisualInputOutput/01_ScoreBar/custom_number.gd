class_name CustomNumber
extends Node2D

const _SPRITE_SIZE: float = 60

@export var min_digits: int
@export var digit_spacing: float

var _spritesheet: Texture = load("res://05_Assets/01_Art/03_UI_Sprites/numbers spritesheet 60 by 60.png")

var _sprites: Array[Sprite2D] = []

var tint_on: bool = false
var tint_col: Color = Color.GREEN

var _digits: int

func _ready() -> void:
	_digits = min_digits
	_init_sprites()

func set_value(val: int) -> void:
	var clamped_val = max(val, 0)
	var val_digits = floor(log(clamped_val) / log(10)) + 1
	val_digits = max(min_digits, val_digits)
	if val_digits != _digits:
		_digits = val_digits
		_remove_sprites()
		_init_sprites()
	
	for i in _digits:
		var sprite_ind = _digits - i - 1
		var digit_val = val % 10 
		val = floor(val / 10.)
		
		_sprites[sprite_ind].frame = digit_val

func _init_sprites() -> void:
	var inc_offset = _SPRITE_SIZE + digit_spacing
	var start_offset = (_digits - 1.0) / 2.0 * inc_offset * -1
	
	for i in _digits:
		var new_sprite = _create_sprite()
		new_sprite.position = Vector2(start_offset + inc_offset * i, 0)
		_sprites.push_back(new_sprite)
		add_child(new_sprite)

func _remove_sprites() -> void:
	for s in _sprites:
		s.queue_free()
	
	_sprites = []

func _create_sprite() -> Sprite2D:
	var sprite = Sprite2D.new()
	sprite.texture = _spritesheet
	sprite.hframes = 10
	return sprite

func toggle_tint(on: bool) -> void:
	tint_on = on
	if tint_on:
		for sprite in _sprites:
			sprite.modulate = tint_col
	else:
		for sprite in _sprites:
			sprite.modulate = Color.WHITE
