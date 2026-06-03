extends Area2D
class_name DeckItem

signal hovered(item: DeckItem)
signal unhovered(item: DeckItem)
signal clicked(item: DeckItem)

## Should we instead propagate ready calls down so this guy instead has like ready()
func _ready() -> void:
	mouse_entered.connect(start_hover)
	pass

func start_hover() -> void:
	hovered.emit(self)
	pass

func on_click() -> void:
	clicked.emit(self)
	pass

func end_hover() -> void:
	unhovered.emit(self)
	pass
