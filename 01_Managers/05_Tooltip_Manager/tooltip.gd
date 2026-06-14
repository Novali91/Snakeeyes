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
var buffer: Vector2 = Vector2(120, 0)

## Set this when we get actual sprite size for the tooltip (currently placeholder)
var sprite_size: Vector2 = Vector2(400, 450)

## References for instantiating values:
@onready var name_label: Label = $Name
@onready var desc_label: RichTextLabel = $Description
@onready var poison_label: Label = $Poison
@onready var strength_label: Label = $Strength
@onready var charm_label: Label = $Charm
@onready var retain_label: Label = $Retain
## Assuming viewport size does NOT change midgame (idk if it can or not)
@onready var viewport_size: Vector2 = get_viewport_rect().size

func _ready() -> void:
	desc_label.add_theme_color_override("default_color", Color())

func _physics_process(_delta: float) -> void:
	# Not visible means it doesn't do stuff!
	if !is_active:
		return
	
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
	visible = true
	pass

func deactivate() -> void:
	is_active = false
	visible = false
	pass

## Used to instantiate the values in the tooltip descriptions using the drink/snake resource
func instantiate_drink_values(info: DrinkResource, og_info: DrinkResource) -> void:
	if info.retain: 
		retain_label.visible = true
	match info.special_ability:
		14:
			name_label.text = info.drink_name
			desc_label.text = info.description + " (" + str(GS.get_antidote_num()) + ")." + "\n" + info.flavour_text
		16:
			name_label.text = info.drink_name
			desc_label.text = info.description + " (" + str(GS.hand_manager.ability_helper.get_total_hand_str()) + ")." + "\n" + info.flavour_text
		21:
			name_label.text = info.drink_name
			desc_label.text = info.description + " (" + str(GS.get_charm()) + ")." + "\n" + info.flavour_text
		22:
			name_label.text = info.drink_name
			desc_label.text = info.description + " (" + str(info.strength/2.0) + ")." + "\n" + info.flavour_text
		_:
			name_label.text = info.drink_name
			desc_label.text = info.description + "\n" + info.flavour_text
	set_val(info.strength, og_info.strength, strength_label, "Strength: ")
	set_psn_val(info.poison, og_info.poison, poison_label)
	set_val(info.charm, og_info.charm, charm_label, "Charm: ")

func instantiate_snake_values(info: SnakeResource, current_drink: DrinkResource) -> void:
	if current_drink.retain: 
		retain_label.visible = true
	match current_drink.special_ability:
		14:
			name_label.text = info.snake_name
			desc_label.text = info.description + " (" + str(GS.get_antidote_num()) + ")." + "\n" + info.flavour_text
		_:
			name_label.text = info.snake_name
			desc_label.text = info.description + "\n" + info.flavour_text
	set_val(current_drink.strength, info.drink_resource.strength, strength_label, "Strength: ")
	set_psn_val(current_drink.poison, info.drink_resource.poison, poison_label)
	set_val(current_drink.charm, info.drink_resource.charm, charm_label, "Charm: ")

func set_val(val: int, og_val: int, label: Label, prefix: String) -> void:
	label.text = prefix + str(val)
	if val == og_val:
		label.label_settings.font_color = Color(0, 0, 0)
	elif val > og_val:
		label.label_settings.font_color = Color(0.05, 1.0, 0.5)
	else:
		label.label_settings.font_color = Color(1.0, 0.3, 0.2)
	pass

func get_rarity(character: String) -> String:
	var new_string: String
	match character:
		"L":
			new_string = "Legendary"
		"R":
			new_string = "Rare"
		"C":
			new_string = "Common"
		"S":
			new_string = "Starter"
	return new_string

func set_psn_val(val: int, og_val: int, label: Label) -> void:
	label.text = "Poison: " + str(val)
	if val == og_val:
		label.label_settings.font_color = Color(0, 0, 0)
	elif val < og_val:
		label.label_settings.font_color = Color(0.05, 1.0, 0.5)
	else:
		label.label_settings.font_color = Color(1.0, 0.3, 0.2)
	pass
