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

enum {
	EASE_IN,
	EASE_OUT
}

var slide_start: Vector2
var slide_target: Vector2
var slide_ind: int

var slide_time: float
var slide_easing: int
var delete_after_slide: bool

var _hover_tween: Tween

func _ready() -> void:
	super._ready()
	instantiate_tooltip()
	set_texture()
	pass

func set_texture() -> void:
	drink_sprite.texture = attached_drink.drink_sprite
	pass

func activate_tooltip() -> void:
	super()
	drink_sprite.material.set_shader_parameter("alpha", 1.0)
	
	if _hover_tween: _hover_tween.kill()
	_hover_tween = create_tween()
	_hover_tween.tween_property(drink_sprite, "position", Vector2(0, -20 * scale.y), 0.1)

func deactivate_tooltip() -> void:
	super()
	drink_sprite.material.set_shader_parameter("alpha", 0.0)
	
	if _hover_tween: _hover_tween.kill()
	_hover_tween = create_tween()
	_hover_tween.tween_property(drink_sprite, "position", Vector2(0, 0), 0.1)

func instantiate_tooltip() -> void:
	tooltip.instantiate_drink_values(attached_drink)
	return
