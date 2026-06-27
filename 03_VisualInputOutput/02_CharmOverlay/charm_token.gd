class_name CharmToken
extends Area2D

signal evil_collided(me: CharmToken, other: CharmToken)

var evil: bool = false
var deleted: bool = false

var spent: bool = false
var spent_dir: Vector2
var spent_dist: float
var wait_timer: float
var spent_timer: float
var vel: Vector2
var after_timer: float
var is_fake: bool = false
var has_reached_bundle: bool = false

@onready var _sprite: Sprite2D = $Sprite
@onready var good_texture: Texture = load("res://05_Assets/01_Art/03_UI_Sprites/charm sprite.png")
@onready var evil_texture: Texture = load("res://05_Assets/01_Art/03_UI_Sprites/EVIL charm sprite.png")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	area_entered.connect(_evil_collided_with_other)
	
	if evil:
		_sprite.texture = evil_texture
		set_collision_mask_value(5, true)
	
	else:
		_sprite.texture = good_texture
		set_collision_layer_value(5, true)

func send_to(pos: Vector2) -> void:
	monitoring = false
	var dir = pos - global_position
	spent_dir = dir.normalized()
	spent_dist = dir.length()

func die() -> void:
	deleted = true
	animation_player.play("fade_out")
	await animation_player.animation_finished
	queue_free()

func _evil_collided_with_other(area: Area2D) -> void:
	evil_collided.emit(self, area as CharmToken)
