extends DeckItem
class_name Drink


## This drink script is probably what we instantiate a lot of
# - It has an attached drink that holds the stats
# - It has an attached_drink_resource that holds the original resource

## Each drink must have set_texture() called at some point before loaded in

## Each attached_drink will have its own number for special ability, play state does the abilities

var attached_drink_resource: DrinkResource
var attached_drink: DrinkResource

@onready var drink_sprite: Sprite2D = $DrinkSprite

func _ready() -> void:
	super._ready()
	tooltip.instantiate_drink_values(attached_drink)
	set_texture()
	pass

func set_texture() -> void:
	drink_sprite.texture = attached_drink.drink_sprite
	pass
