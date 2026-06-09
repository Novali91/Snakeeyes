extends Sprite2D

@onready var _animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	_animation_player.play("default")
	await _animation_player.animation_finished
	queue_free()
