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

@onready var _sprite: Sprite2D = $Sprite

func _ready() -> void:
	area_entered.connect(_evil_collided_with_other)
	
	if evil:
		_sprite.material.set_shader_parameter("strength", 1.)
		set_collision_mask_value(5, true)
	
	else:
		set_collision_layer_value(5, true)

func send_to(pos: Vector2) -> void:
	monitoring = false
	var dir = pos - global_position
	spent_dir = dir.normalized()
	spent_dist = dir.length()

func _evil_collided_with_other(area: Area2D) -> void:
	evil_collided.emit(self, area as CharmToken)
