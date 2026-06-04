extends Node2D
class_name Tooltip

## How it's used: Each drink/snake has a child tooltip node
## When that drink/snake is hovered, it will tell tooltip_manager
## If no other tooltips with higher priority are hovered, then this tooltip shows up
## activate() makes it visible and turns it on, deactivate() deactivates it
## Drink/Snake needs to instantiate(resource) this with info

## Tooltip positions:
const TOP_RIGHT: int = 0
const TOP_LEFT: int = 1
const BOTTOM_RIGHT: int = 2
const BOTTOM_LEFT: int = 3
# Used to set visibility of Sprite
@onready var tooltip_sprite = $TooltipSprite

var is_active: bool = false

# Math stuff
## Question: Does tooltip appearing over sprite seem bad? Should buffer always push it off?
var buffer: Vector2 = Vector2(40, 0)

## Set this when we get actual sprite size for the tooltip (currently placeholder)
var sprite_size: Vector2 = Vector2(250, 350)

## References for instantiating values:
@onready var name_label: Label = $Name
@onready var desc_label: Label = $Description
@onready var flavour_label: Label = $FlavourText
@onready var poison_label: Label = $Poison
@onready var strength_label: Label = $Strength
@onready var charm_label: Label = $Charm

## Assuming viewport size does NOT change midgame (idk if it can or not)
@onready var viewport_size: Vector2 = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	# Not visible means it doesn't do stuff!
	if !is_active:
		pass
	
	global_position = calculate_position()
	pass

## Helper function to find position for tooltip to appear
# Currently, outputs position assuming that the tooltip sprite is bottomright-
# -of origin of tooltip scene
func calculate_position() -> Vector2:
	# Top-left corner of the screen - global position
	var viewport_position: Vector2 = get_viewport().get_visible_rect().position
	# Mouse position - relative position to viewport
	var global_mouse_position: Vector2 = get_global_mouse_position()
	var screen_mouse_position: Vector2 = get_viewport().get_mouse_position()
	
	# Finds where tooltip appears proportional to cursor
	var position_spot: int = get_spot(screen_mouse_position)
	
	match position_spot:
		TOP_RIGHT:
			return Vector2(viewport_position.x+global_mouse_position.x+buffer.x,\
			viewport_position.y + global_mouse_position.y - buffer.y - sprite_size.y)
		TOP_LEFT:
			return Vector2(viewport_position.x+global_mouse_position.x-buffer.x-sprite_size.x,\
			viewport_position.y + global_mouse_position.y - buffer.y - sprite_size.y)
		BOTTOM_RIGHT:
			return Vector2(viewport_position.x+global_mouse_position.x+buffer.x,\
			viewport_position.y + global_mouse_position.y + buffer.y)
		BOTTOM_LEFT:
			return Vector2(viewport_position.x+global_mouse_position.x-buffer.x-sprite_size.x,\
			viewport_position.y + global_mouse_position.y + buffer.y)
	
	return Vector2.ZERO

## Helper function for calculate_position:
# Calculates where the tooltip fits (what position from the cursor)
# Priority order: top right > top left > bottom right > bottom left
func get_spot(mouse_position: Vector2) -> int:
	if (mouse_position.x + (2*buffer.x) + sprite_size.x) <= viewport_size.x && \
	(mouse_position.y - (buffer.y) - sprite_size.y) >= 0:
		return TOP_RIGHT
	elif (mouse_position.x - (2*buffer.x) - sprite_size.x) >= 0 && \
	(mouse_position.y - (buffer.y) + sprite_size.y) >= viewport_size.y:
		return TOP_LEFT
	elif (mouse_position.x + (2*buffer.x) + sprite_size.x) <= viewport_size.x && \
	(mouse_position.y + (buffer.y) - sprite_size.y) <= viewport_size.y:
		return BOTTOM_RIGHT
	else:
		return BOTTOM_LEFT

func activate() -> void:
	is_active = true
	tooltip_sprite.visible = true
	name_label.visible = true
	desc_label.visible = true
	flavour_label.visible = true
	poison_label.visible=true
	strength_label.visible = true
	charm_label.visible = true
	pass

func deactivate() -> void:
	is_active = false
	tooltip_sprite.visible = false
	tooltip_sprite.visible = false
	name_label.visible = false
	desc_label.visible = false
	flavour_label.visible = false
	poison_label.visible=false
	strength_label.visible = false
	charm_label.visible = false
	pass

## Used to instantiate the values in the tooltip descriptions using the drink/snake resource
func instantiate_drink_values(info: DrinkResource) -> void:
	name_label.text = info.drink_name
	desc_label.text = info.description
	flavour_label.text = info.flavour_text
	poison_label.text = "Poison: " + str(info.poison)
	strength_label.text = "Strength: " + str(info.strength)
	charm_label.text = "Charm: " + str(info.charm)
	
	pass

func instantiate_snake_values(info: SnakeResource) -> void:
	name_label.text = info.snake_name
	desc_label.text = info.description
	flavour_label.text = info.flavour_text
	poison_label.text = "Poison: " + str(info.attached_drink_resource.poison)
	strength_label.text = "Strength: " + str(info.attached_drink_resource.strength)
	charm_label.text = "Charm: " + str(info.attached_drink_resource.charm)
	
	pass
