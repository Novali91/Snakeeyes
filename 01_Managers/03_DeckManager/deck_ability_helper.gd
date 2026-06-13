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
	GS.sound_manager.play_click()
	return snake

func upgrade_snake(snake: Snake, increase: int, stat: int) -> void:
	match stat:
		POISON:
			snake.current_drink.poison += increase
		STRENGTH:
			snake.current_drink.strength += increase
		CHARM:
			snake.current_drink.charm += increase
		NUM_DRINKS:
			pass
	snake.instantiate_tooltip()

func get_clairvoyant_drink(snake: Snake) -> Drink:
	var temp_drink: DrinkResource = snake.current_drink.duplicate()
	var og_temp_drink: DrinkResource = snake.current_drink
	temp_drink.poison = 0
	var temp: Drink = _dm.create_drink(temp_drink, og_temp_drink)
	return temp

func increment_familiar_snakes(value: int) -> void:
	for snake in _dm.snake_deck:
		if snake.attached_snake.snake_name == "Familiar Snake":
			snake.current_drink.strength += value
			snake.instantiate_tooltip()
	return
