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
	hm.slide_manager.begin_slide_back(drink)
	return

func give_drink_retain(drink: Drink) -> void:
	drink.attached_drink.retain = true
	if drink.attached_drink.description == "No ability.":
		drink.attached_drink.description = "Stays on the table between turns."
	else: 
		drink.attached_drink.description += " Stays on the table between turns."
	
	drink.instantiate_tooltip()
	return

func change_poison_values_in_hand(change: int) -> void:
	for drink in hm.drinks:
		drink.attached_drink.poison -= change
		drink.instantiate_tooltip()
	return
