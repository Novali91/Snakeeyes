extends Node2D
class_name DeckManager

## Right now, this script's responsibilities are managing the snake_deck and the drink_drawpile
# How to use this code rn:
# When you need to draw a certain amount, call draw(int)
# Something must call empty_drink() when a drink is drank!
# Something must call new_turn at the start of each turn/end of each turn
# When adding or removing snakes, call add_snake/remove_snake

## Todo: Add more stuff in init (like creating our first snakedeck/etc)

@export var snake_deck: Array[Snake]
@export var drink_drawpile: Array[Drink]

@onready var _drink_scene = preload("res://02_Deck/01_Drinks/drink.tscn")

@onready var tooltip_manager: TooltipManager = $TooltipManager
@onready var ability_helper: DeckAbilityHelper = $DeckAbilityHelper

signal snake_chosen(snake: Snake)

## Draw function: Currently if drawing too much for drawpile, it returns an array of size amt-
## -but for each drink that is "overflow", it just has a null

func _ready() -> void:
	tooltip_manager.child_was_clicked.connect(_child_clicked)
	return

func draw(amt: int) -> Array[Drink]:
	var new_array: Array[Drink]
	var temp_drink: Drink
	for i in range(amt):
		temp_drink = drink_drawpile.pop_back()
		# If the drawpile is empty:
		if temp_drink == null:
			return new_array
		new_array.push_back(temp_drink)
		tooltip_manager.remove_item(temp_drink, false)
	
	return new_array
	

func reshuffle_drawpile() -> void:
	# Maybe this is where we put the animation for refilling the drinks if we want one?
	for snake: Snake in snake_deck:
		var new_drink: Drink = create_drink(snake.current_drink, snake.attached_snake.drink_resource)
		drink_drawpile.push_back(new_drink)
		tooltip_manager.add_item(new_drink)
	
	shuffle_drawpile()
	pass

func create_drink(drink_resource: DrinkResource, og_drink_resource: DrinkResource) -> Drink:
	var new_drink: Drink = _drink_scene.instantiate()
	new_drink.attached_drink = drink_resource.duplicate()
	new_drink.attached_drink_resource = og_drink_resource
	new_drink.global_position = Vector2(200 + drink_drawpile.size() * 50, 800)
	return new_drink

## Not sure how removing snakes will work
func remove_snake(snake) -> void:
	for i in range(snake_deck.size()):
		if snake_deck[i] == snake:
			tooltip_manager.remove_item(snake, true)
			snake_deck.remove_at(i)
			# Probably will do more stuff here (like visuals)
			break
	pass

## Idk where we want the animation to be placed (if we have one?)
func add_snake(new_snake: Snake) -> void:
	snake_deck.push_back(new_snake)
	new_snake.global_position = Vector2(200 + snake_deck.size() * 50, 1080 / 2.)
	tooltip_manager.add_item(new_snake)
	pass

func shuffle_drawpile() -> void:
	drink_drawpile.shuffle()
	pass

func return_to_drawpile(drink: Drink):
	var new_drink: Drink = create_drink(drink.attached_drink, drink.attached_drink_resource)
	drink_drawpile.push_back(new_drink)
	tooltip_manager.add_item(new_drink)
	shuffle_drawpile()
	pass

func _child_clicked(child: DeckItem) -> void:
	if child is Snake:
		snake_chosen.emit(child)
	return
