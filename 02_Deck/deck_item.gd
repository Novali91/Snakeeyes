extends Area2D
class_name DeckItem


## These signals are used by tooltip_manager (the parent of any snakes and/or drinks)
signal hovered(item: DeckItem)
signal unhovered(item: DeckItem)
signal clicked(item: DeckItem)

@onready var tooltip: Tooltip = $Tooltip

## Used to buffer hovers: if unhovered, can't rehover immediately
const HOVER_BUFFER_TIME: float = 0.05
var hover_buffer_timer: float = HOVER_BUFFER_TIME

func _ready() -> void:
	mouse_entered.connect(start_hover)
	mouse_exited.connect(end_hover)
	pass

func _physics_process(delta: float) -> void:
	hover_buffer_timer = move_toward(hover_buffer_timer, 0, delta)
	pass

func start_hover() -> void:
	# For tooltip_manager
	#if hover_buffer_timer == 0:
		#hover_buffer_timer = HOVER_BUFFER_TIME
	hovered.emit(self)
	pass

func end_hover() -> void:
	# For tooltip_manager
	#hover_buffer_timer = HOVER_BUFFER_TIME
	unhovered.emit(self)
	pass

func activate_tooltip() -> void:
	tooltip.activate()
	pass

func deactivate_tooltip() -> void:
	tooltip.deactivate()
	pass

## Handles drink being clicked -- Look in notes app for idea
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			# For tooltip_manager
			clicked.emit(self)
