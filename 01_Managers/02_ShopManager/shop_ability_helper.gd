class_name ShopAbilityHelper
extends Node

## Constants for snakes with on-bought effects
const KING_COBRA: int = 13

var shop_manager: ShopManager
var top_ability_helper:  AbilityHelper

func increase_antidote_count(increase: int) -> void:
	## Maybe some visuals?
	shop_manager.antidote_stock += increase
	return

func buy_snake(snake: Snake) -> void:
	match snake.current_drink.special_ability:
		KING_COBRA:
			top_ability_helper.remove_snake(2)
		_:
			return
