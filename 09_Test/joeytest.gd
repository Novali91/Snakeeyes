extends Node2D

var deckitempath = "res://02_Deck/deck_item.tscn"
@onready var tooltip_manager = $TooltipManager

func _ready() -> void:
	var item1: Drink = preload("res://02_Deck/01_Drinks/drink.tscn").instantiate()
	var item2 = preload("res://02_Deck/01_Drinks/drink.tscn").instantiate()
	var item3 = preload("res://02_Deck/01_Drinks/drink.tscn").instantiate()
	
	tooltip_manager.add_item(item1)
	tooltip_manager.add_item(item2)
	tooltip_manager.add_item(item3)
	
	item1.position = Vector2(400, 500)
	item2.position = Vector2(400, 500)
	item3.position = Vector2(400, 500)
	
	item1.drink_sprite.texture = preload("res://icon.svg")
	pass
