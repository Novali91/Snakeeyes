class_name DeckAbilityHelper
extends Node

enum {
	POISON,
	STRENGTH,
	CHARM,
	NUM_DRINKS
}

@onready var _dm: DeckManager = get_parent()

func choose_snake() -> Snake:
	## Put some UI thing here? Or does play ability helper do this?
	var snake: Snake = await _dm.snake_chosen
	
	return snake

func upgrade_snake(snake: Snake, increase: int, stat: int) -> void:
	match stat:
		POISON:
			snake.current_drink.poison -= increase
		STRENGTH:
			snake.current_drink.strength += increase
		CHARM:
			snake.current_drink.charm += increase
		NUM_DRINKS:
			pass
	snake.instantiate_tooltip()

func get_clairvoyant_drink(snake: Snake) -> DrinkResource:
	var temp_drink: DrinkResource = snake.current_drink.duplicate()
	temp_drink.poison = temp_drink.poison * 2
	return temp_drink
