extends Node2D
class_name Drink

## This drink script is probably what we instantiate a lot of
# - It has an attached drink that holds the stats
# - It will hold all special abilities so call special ability on the drink script when it is drank

var attached_drink: DrinkResource

@onready var drink_sprite: Sprite2D = $DrinkSprite

# Each attached_drink will have its own number for a special ability and we will-
# -use a switch statement maybe
func special_effect() -> void:
	match attached_drink.special_ability:
		# No ability
		0:
			pass
	pass

func set_texture() -> void:
	drink_sprite.texture = attached_drink.drink_sprite
	pass
