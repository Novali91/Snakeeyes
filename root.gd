extends Node2D

@onready var screens: Array[Node2D] = [$Deck,$Table,$Store]
var screenId = 1
@onready var camera = $Camera2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right"):
		screenId += 1
	if Input.is_action_just_pressed("ui_left"):
		screenId -= 1
	screenId = clamp(screenId, 0, 2)
	camera.global_position = screens[screenId].global_position
	pass
