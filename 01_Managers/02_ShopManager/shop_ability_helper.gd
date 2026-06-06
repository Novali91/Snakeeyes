class_name ShopAbilityHelper
extends Node

var sm: ShopManager

func increase_antidote_count(increase: int) -> void:
	## Maybe some visuals?
	sm.antidote_stock += increase
	return
