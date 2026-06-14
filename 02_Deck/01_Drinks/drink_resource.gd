class_name DrinkResource
extends Resource

## Each specific drink has its own resource with its stats. Snakes produce these (in drinkmanager)

## These are attached to a drink.gd script which is in a cup scene

@export var drink_name: String
@export var drink_sprite: Texture2D
# Drink stats
@export var poison: int
@export var strength: int
@export var charm: int
@export var special_ability: int
@export var cost: int

var parent_snake: Snake

@export var retain: bool = false

# For tooltip
@export var description: String = "No ability."
@export var flavour_text: String
@export var rarity: String
