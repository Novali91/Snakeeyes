extends Node2D

@onready var screens: Array[Node2D] = [$Deck,$Table,$Store]
var screenId = 1
@onready var camera = $Camera2D
var SCREEN_SIZE #Make this global later

var prevScreenId = 1
var transitionTotalTime = 0.75
var transitionTime = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SCREEN_SIZE = camera.get_viewport_rect().size
	#Just give the player a hand of blank, example drinks
	$Table.begin_slide_cups([DrinkResource.new(),DrinkResource.new(),DrinkResource.new(),DrinkResource.new(),DrinkResource.new()] as Array[DrinkResource])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if transitionTime > -1 && transitionTime < transitionTotalTime:
		transitionTime += delta
		camera.global_position = smooth_lerp(screens[prevScreenId].global_position, screens[screenId].global_position, transitionTime/transitionTotalTime)
	else:
		if Input.is_action_just_pressed("right"):
			transition_screens(1)
		if Input.is_action_just_pressed("left"):
			transition_screens(-1)

func smooth_lerp(from: Vector2, to: Vector2, x: float) -> Vector2:
	return from + (to - from) * smooth_func(x)

func smooth_func(x: float) -> float:
	return sin(PI * (x - 0.5))/2 + 0.5

func transition_screens(dir: int) -> void:
	prevScreenId = screenId
	screenId = clamp(screenId + dir, 0, 2)
	transitionTime = 0
