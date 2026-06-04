extends Node2D

var deckitempath = "res://02_Deck/deck_item.tscn"
var drink_resource: DrinkResource = load("res://02_Deck/01_Drinks/01_SpecificDrinks/starting_charm_drink.tres")
@onready var tooltip_manager = $TooltipManager

func _ready() -> void:
	var item1: Drink = preload("res://02_Deck/01_Drinks/drink.tscn").instantiate()
	var item2 = preload("res://02_Deck/01_Drinks/drink.tscn").instantiate()
	var item3 = preload("res://02_Deck/01_Drinks/drink.tscn").instantiate()
	
	item1.attached_drink_resource = drink_resource
	item1.attached_drink = drink_resource.duplicate()
	item2.attached_drink_resource = drink_resource
	item2.attached_drink = drink_resource.duplicate()
	item3.attached_drink_resource = drink_resource
	item3.attached_drink = drink_resource.duplicate()
	tooltip_manager.add_item(item1)
	tooltip_manager.add_item(item2)
	tooltip_manager.add_item(item3)
	
	item1.position = Vector2(200, 300)
	item2.position = Vector2(600, 200)
	item3.position = Vector2(400, 500)
	
	item1.drink_sprite.texture = preload("res://icon.svg")
	pass
