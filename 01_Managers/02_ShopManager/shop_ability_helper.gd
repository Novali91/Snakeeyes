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
			if top_ability_helper.sm.deck_manager.snake_deck.size() <= 5:
				return
			var stats: Vector4i = await top_ability_helper.king_cobra_remove(2)
			if snake != null:
				snake.current_drink.strength += stats.w+stats.y
				snake.current_drink.charm += stats.x+stats.z
		_:
			return
