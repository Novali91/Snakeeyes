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

func clairvoyant_copy(snake: Snake) -> void:
	pass
