class_name HandManager
extends Node2D

const Y_POSITION_DRINKS: int = 800

var cur_num_drinks: int = 0

# Placeholder for now
var drink_slots: Array[Drink]
@onready var tooltip_manager: TooltipManager = $TooltipManager

var drinks_drinkable: bool = true
signal drink_clicked(resource: DrinkResource)

func _ready() -> void:
	drink_slots.resize(10)
	tooltip_manager.child_was_clicked.connect(_click_drink)
	pass

func get_num_drinks() -> int:
	return cur_num_drinks


## Bug: For some reason this is called twice? Is that normal?
func draw_drinks(new_drinks: Array[Drink]) -> void:
	
	var cur_drink: int = 0
	var new_drink: Drink = null
	for i: int in range(drink_slots.size()):
		if cur_drink >= new_drinks.size():
			return
		new_drink = new_drinks[cur_drink]
		cur_drink += 1
		if drink_slots[i] == null:
			tooltip_manager.add_item(new_drink)
			drink_slots[i] = new_drink
			## For some reason their position doesn't update
			new_drink.position = Vector2((i+1)*100, 800)
	pass

func _click_drink(drink: Drink) -> void:
	if !drinks_drinkable:
		return
	drink_clicked.emit(drink.attached_drink)
	remove_drink(drink)
	pass

func remove_drink(drink: Drink) -> void:
	for i: int in range(drink_slots.size()):
		i-=1
		if drink_slots[i] == drink:
			drink_slots.remove_at(i)
			drink_slots.insert(i, null)
	
	tooltip_manager.remove_item(drink, true)
	pass

func end_turn_discard() -> void:
	for i: int in range(drink_slots.size()):
		i-=1
		if drink_slots[i] is Drink:
			remove_drink(drink_slots[i])
	pass
