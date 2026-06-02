extends Node
class_name Drink

## This drink script is probably what we instantiate a lot of
# - It has an attached drink that holds the stats
# - It will hold all special abilities so call special ability on the drink script when it is drank

var attached_drink: DrinkResource

# Each attached_drink will have its own number for a special ability and we will-
# -use a switch statement maybe
func special_effect() -> void:
	pass
