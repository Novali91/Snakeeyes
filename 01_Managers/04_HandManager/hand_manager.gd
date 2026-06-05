class_name HandManager
extends Node2D

const Y_POSITION_DRINKS: int = 800

var cur_num_drinks: int = 0

var drinks_in_hand: Array[Drink]

@onready var tooltip_manager: TooltipManager = $TooltipManager
@onready var slide_manager: SlideManager = $SlideManager
@onready var ability_helper: HandAbilityHelper = $HandAbilityHelper

var drinks_drinkable: bool = true

## For when a drink is drinkable and is clicked (play state connected to this)
signal drink_clicked(resource: DrinkResource) ## Rename to drink_drank
## For when a drink is not drinkable and is clicked (hand_ability_helper maybe connected)
signal drink_chosen(drink: Drink)

func _ready() -> void:
	tooltip_manager.child_was_clicked.connect(_click_drink)
	pass

func get_num_drinks() -> int:
	return cur_num_drinks


## Bug: For some reason this is called twice? Is that normal?
func draw_drinks(new_drinks: Array[Drink]) -> void:
	for drink in new_drinks:
		tooltip_manager.add_item(drink)
		drinks_in_hand.append(drink)
	slide_manager.begin_slide_drinks_in(drinks_in_hand)

func _click_drink(drink: Drink) -> void:
	if !drinks_drinkable:
		drink_chosen.emit(drink)
		return
	drink_clicked.emit(drink.attached_drink)
	remove_drink(drink)
	tooltip_manager.remove_item(drink, true)
	pass

## 
func remove_drink(drink_to_remove: Drink) -> void:
	for i: int in range(drinks_in_hand.size()):
		if drinks_in_hand[i] == drink_to_remove:
			drinks_in_hand.remove_at(i)
			break

func end_turn_discard() -> void:
	for i: int in range(drinks_in_hand.size()):
		if drinks_in_hand[i] is Drink:
			tooltip_manager.remove_item(drinks_in_hand[i], true)
	drinks_in_hand.clear()
