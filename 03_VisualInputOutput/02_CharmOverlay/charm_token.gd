class_name CharmToken
extends Sprite2D

var spent: bool = false
var spent_dir: Vector2
var spent_dist: float
var wait_timer: float
var vel: Vector2

func send_to(pos: Vector2) -> void:
	var dir = pos - global_position
	spent_dir = dir.normalized()
	spent_dist = dir.length()
