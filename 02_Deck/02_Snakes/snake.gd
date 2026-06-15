extends DeckItem
class_name Snake

## How to use: attached_snake stores the snake stats
# - attached_snake holds attached_drink which holds all of the drink effects
# - Before snakes are visible, we need to run set_texture (idk if we want it in _ready() or not)

@export var attached_snake: SnakeResource
var current_drink: DrinkResource

@onready var num_drinks: int = attached_snake.num_drinks

# Reference to our sprite so that we can set the texture
@onready var snake_sprite: Sprite2D = $SnakeSprite
@onready var _animation_player: AnimationPlayer = $AnimationPlayer

var deck_index: int = -1

func _ready() -> void:
	super._ready()
	instantiate_tooltip()
	set_texture()
	current_drink.rarity = attached_snake.rarity
	attached_snake.flavour_text = "[i]" + attached_snake.flavour_text + "[/i]"
	current_drink.flavour_text = "[i]" + current_drink.flavour_text + "[/i]"
	
	match current_drink.rarity:
		"R":
			attached_snake.snake_name = "[color=#1f5782]" + attached_snake.snake_name
			current_drink.drink_name = "[color=#1f5782]" + current_drink.drink_name
		
		"L":
			attached_snake.snake_name = "[wave amp=50.0 freq=5.0 connected=1][rainbow freq=2.0 sat=1.0 val=0.725 speed=0.8]" + attached_snake.snake_name
			current_drink.drink_name = "[wave amp=50.0 freq=5.0 connected=1][rainbow freq=2.0 sat=1.0 val=0.725 speed=0.8]" + current_drink.drink_name
	
	if current_drink.special_ability == 26:
		attached_snake.snake_name = "[rainbow freq=3.0 sat=1.0 val=0.725 speed=0.2]" + attached_snake.snake_name
		current_drink.drink_name = "[rainbow freq=3.0 sat=1.0 val=0.725 speed=0.2]" + current_drink.drink_name
	
	pass

func set_texture() -> void:
	snake_sprite.texture = attached_snake.snake_sprite
	snake_sprite.material.set_shader_parameter("color", GS.RARITY_TO_COLOR[attached_snake.rarity])

func instantiate_tooltip() -> void:
	tooltip.instantiate_snake_values(attached_snake, current_drink)
	return

func activate_tooltip() -> void:
	super()
	snake_sprite.material.set_shader_parameter("thickness", 0.015)
	_animation_player.play("default")
	
	tooltip.instantiate_snake_values(attached_snake, current_drink)

func deactivate_tooltip() -> void:
	super()
	snake_sprite.material.set_shader_parameter("thickness", 0.01)
	
	_animation_player.play("RESET")

func delete_snake() -> void:
	_animation_player.play("fade")
	await _animation_player.animation_finished
	queue_free()
