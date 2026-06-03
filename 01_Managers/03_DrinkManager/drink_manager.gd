extends Node

## Right now, this script's responsibilities are managing the snake_deck and the drink_drawpile
# How to use this code rn:
# When you need to draw a certain amount, call draw(int)
# Something must call empty_drink() when a drink is drank!
# Something must call new_turn at the start of each turn/end of each turn
# When adding or removing snakes, call add_snake/remove_snake

## Todo: Add more stuff in init (like creating our first snakedeck/etc)

@export var snake_deck: Array[SnakeResource]
@export var drink_drawpile: Array[DrinkResource]

# Not sure if we're doing a maximum handsize, but if we are, this is the logic:
const MAX_HAND_SIZE: int = 12
var cur_hand_amt: int

func _init() -> void:
	reshuffle_drawpile()
	pass

## Draw function: Currently if drawing too much for drawpile, it will refill drawpile
## and finish drawing in the same step
func draw(amt: int) -> Array[DrinkResource]:
	# Maximum handsize logic
	if amt > (MAX_HAND_SIZE - cur_hand_amt):
		amt = MAX_HAND_SIZE - cur_hand_amt
	
	var new_array: Array[DrinkResource]
	var temp_drink: DrinkResource
	for i in range(amt):
		temp_drink = drink_drawpile.pop_back()
		# If the drawpile is empty:
		if temp_drink == null:
			reshuffle_drawpile()
			# Easy fix, but potential issue is if even after reshuffling, drawpile is still empty
			
			# Also rn this just reshuffles and then gives it all at once, not like slay the spire-
			# -where if draw pile has 3 and you draw 5, you get 3 cards, then reshuffle animation-
			# -plays and then you draw the final 2. If we wanted that, maybe we call reshuffle-
			# -then call a new draw function with the remaining amt?
			temp_drink = drink_drawpile.pop_back()
		new_array.push_back(temp_drink)
	
	cur_hand_amt += amt
	return new_array
	

func reshuffle_drawpile() -> void:
	# Maybe this is where we put the animation for refilling the drinks if we want one?
	for snake in snake_deck:
		drink_drawpile.push_back(snake.attached_drink)
	drink_drawpile.shuffle()
	pass

## Presumably called whenever you a drink gets drank!
func empty_drink() -> void:
	cur_hand_amt -= 1
	pass

## Presumably called at the start of a new turn/at some upkeep
func new_turn() -> void:
	cur_hand_amt = 0
	pass

## Not sure how removing snakes will work, but rn it uses the name of the snake ig
func remove_snake(name: String) -> void:
	for i in range(snake_deck.size()):
		if snake_deck[i].name == name:
			snake_deck.remove_at(i)
			break
	pass

## Idk where we want the animation to be placed (if we have one?)
func add_snake(new_snake: SnakeResource) -> void:
	snake_deck.push_back(new_snake)
	pass
