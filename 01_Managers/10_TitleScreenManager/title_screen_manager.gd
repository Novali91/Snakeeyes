class_name TitleScreenManager
extends Node2D

signal play_clicked()

@onready var _area: Area2D = $Area2D
@onready var _bubble: Sprite2D = $Bubble
@onready var _collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var _clicked: bool = false

func _ready() -> void:
	_area.mouse_entered.connect(_mouse_entered)
	_area.mouse_exited.connect(_mouse_exited)

func _process(_delta: float) -> void:
	if _clicked: return
	
	if Input.is_action_just_pressed("click"):
		var dist = get_local_mouse_position().length()
		var radius = _collision_shape.shape.radius
		if dist <= radius:
			_clicked = true
			
			_animation_player.play("fade_out")
			await _animation_player.animation_finished
			play_clicked.emit()

func _mouse_entered() -> void:
	_bubble.material.set_shader_parameter("alpha", 1)

func _mouse_exited() -> void:
	_bubble.material.set_shader_parameter("alpha", 0)
