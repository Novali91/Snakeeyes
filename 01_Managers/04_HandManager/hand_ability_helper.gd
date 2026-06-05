class_name HandAbilityHelper
extends Node

## This class is the helper for abilities that fall under hand_manager's domain
## Play_state's ability_helper will call something in this when a drink-
## -is drank with an ability that falls under this helper's domain

@onready var hm: HandManager = get_parent()

func choose_drink() -> Drink:
	## Probably displays some UI, but I'm guessing Play's AbilityHelper will do this?
	## Probably locks camera, but ^^^^^
	hm.drinks_drinkable = false
	
	var drink: Drink = await hm.drink_chosen
	
	hm.drinks_drinkable = true
	return drink

func slide_drink_back(drink: Drink) -> void:
	drink.input_pickable = false ## Placeholder: Is this how we want to do this?
	## hm.slide_manager.slide_back(drink) -- to be added fully when slide_manager is implemented
	## Maybe wait for animation to finish (or does slide_manager do this?)
	hm.remove_drink(drink)
	hm.tooltip_manager.remove_item(drink, true)
	return
