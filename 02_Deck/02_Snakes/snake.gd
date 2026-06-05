extends DeckItem
class_name Snake

## How to use: attached_snake stores the snake stats
# - attached_snake holds attached_drink which holds all of the drink effects
# - Before snakes are visible, we need to run set_texture (idk if we want it in _ready() or not)

@export var attached_snake: SnakeResource
var current_drink: DrinkResource

# Reference to our sprite so that we can set the texture
@onready var snake_sprite: Sprite2D = $SnakeSprite

func _ready() -> void:
	super._ready()
	instantiate_tooltip()
	set_texture()
	pass

func set_texture() -> void:
	snake_sprite.texture = attached_snake.snake_sprite
	pass

func instantiate_tooltip() -> void:
	tooltip.instantiate_snake_values(attached_snake, current_drink)
	return

func activate_tooltip() -> void:
	super()
	snake_sprite.material.set_shader_parameter("alpha", 1.0)

func deactivate_tooltip() -> void:
	super()
	snake_sprite.material.set_shader_parameter("alpha", 0.0)
