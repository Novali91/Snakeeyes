class_name HandManager
extends Node2D

## When cards drawn, put them on screen
## When cards clicked, emit signal
## - Also have remove functionality (talking to tooltip manager)
## Bool on if cards can be clicked/played

const Y_POSITION_DRINKS: int = 800

var cur_num_drinks: int = 0

# Placeholder for now
var drink_slots: Array[Drink]
@onready var tooltip_manager: TooltipManager = $TooltipManager

func _ready() -> void:
	drink_slots.resize(10)
	tooltip_manager.child_was_clicked.connect(_click_drink)
	pass

func get_num_drinks() -> int:
	return cur_num_drinks


func draw_drinks(new_drinks: Array[Drink]) -> void:
	var cur_drink: int = 0
	var new_drink: Drink = null
	for i: int in range(drink_slots):
		new_drink = new_drinks[cur_drink]
		cur_drink += 1
		if drink_slots[i] == null:
			drink_slots[i] = new_drink
			new_drink.position = Vector2((i+1)*100, 800)
			tooltip_manager.add_item(new_drink)
	pass

func _click_drink(drink: Drink) -> void:
	
