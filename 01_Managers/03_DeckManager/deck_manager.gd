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

# Not sure if we're doing a maximum handsize, but if we are, this is the logic:
const MAX_HAND_SIZE: int = 12
var cur_hand_amt: int

const DRINK_FILEPATH: String = "res://02_Deck/01_Drinks/drink.tscn"

@onready var tooltip_manager: TooltipManager = $TooltipManager

func _init() -> void:
	reshuffle_drawpile()
	pass

## Draw function: Currently if drawing too much for drawpile, it returns an array of size amt-
## -but for each drink that is "overflow", it just has a null

func draw(amt: int) -> Array[Drink]:
	# Maximum handsize logic
	#if amt > (MAX_HAND_SIZE - cur_hand_amt):
		#amt = MAX_HAND_SIZE - cur_hand_amt
	
	var new_array: Array[Drink]
	var temp_drink: Drink
	for i in range(amt):
		temp_drink = drink_drawpile.pop_back()
		# If the drawpile is empty:
		#if temp_drink == null:
			#reshuffle_drawpile()
			#temp_drink = drink_drawpile.pop_back()
		new_array.push_back(temp_drink)
	
	return new_array
	

func reshuffle_drawpile() -> void:
	# Maybe this is where we put the animation for refilling the drinks if we want one?
	for snake: Snake in snake_deck:
		var new_drink: Drink = create_drink(snake.attached_snake.attached_drink, snake.attached_snake.attached_drink_resource)
	shuffle_drawpile()
	pass

func create_drink(drink_resource: DrinkResource, og_drink_resource: DrinkResource) -> Drink:
	var new_drink: Drink = preload(DRINK_FILEPATH).instantiate()
	new_drink.attached_drink = drink_resource.duplicate()
	new_drink.attached_drink_resource = og_drink_resource
	# Maybe we need to add other info to this (eg global position)? This is probably where we'd do it
	return new_drink

## Presumably called whenever you a drink gets drank!
# Will be ported to HandManager ig
func empty_drink() -> void:
	cur_hand_amt -= 1
	pass

## Presumably called at the start of a new turn/at some upkeep
# Will be ported to HandManager ig
func new_turn() -> void:
	cur_hand_amt = 0
	pass

## Not sure how removing snakes will work, but rn it uses the name of the snake ig
func remove_snake(name: String) -> void:
	for i in range(snake_deck.size()):
		if snake_deck[i].attached_snake.name == name:
			snake_deck.remove_at(i)
			# Probably will do more stuff here (like visuals)
			break
	pass

## Idk where we want the animation to be placed (if we have one?)
func add_snake(new_snake: Snake) -> void:
	snake_deck.push_back(new_snake)
	pass

func shuffle_drawpile() -> void:
	drink_drawpile.shuffle()
	pass

func return_to_drawpile(drink: Drink):
	drink_drawpile.push_back(drink)
	shuffle_drawpile()
	
	# Will be ported to HandManager ig
	cur_hand_amt -= 1
	pass
