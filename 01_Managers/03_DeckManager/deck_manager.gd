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

@onready var _markers_node: Node2D = $Markers
@onready var _current_count: CustomNumber = $CurrentCount

signal snake_chosen(snake: Snake)

## Draw function: Currently if drawing too much for drawpile, it returns an array of size amt-
## -but for each drink that is "overflow", it just has a null


var _all_slots: Array[Vector2]
var _open_slot_inds: Array[int]

@onready var _venom_drop_texture: Texture = preload("res://05_Assets/01_Art/03_UI_Sprites/poison drop for refill.png")
@onready var _venom_drops: Node2D = $VenomDrops

func _ready() -> void:
	
	_all_slots = []
	_open_slot_inds = []
	
	var i = 0
	for m: Marker2D in _markers_node.get_children():
		_all_slots.push_back(m.position)
		_open_slot_inds.push_back(i)
		
		i += 1
	
	tooltip_manager.child_was_clicked.connect(_child_clicked)

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
	await _refill_animation()
	
	for snake: Snake in snake_deck:
		for num_drink: int in snake.num_drinks:
			var new_drink: Drink = create_drink(snake.current_drink, snake.attached_snake.drink_resource, snake)
			drink_drawpile.push_back(new_drink)
			tooltip_manager.add_item(new_drink)
	
	shuffle_drawpile()
	pass

func create_drink(drink_resource: DrinkResource, og_drink_resource: DrinkResource, snake: Snake) -> Drink:
	var new_drink: Drink = _drink_scene.instantiate()
	new_drink.attached_drink = drink_resource.duplicate()
	new_drink.attached_drink_resource = og_drink_resource
	if snake != null:
		new_drink.global_position = snake.global_position + Vector2(0, 100)
		new_drink.attached_drink.parent_snake = snake
	else:
		new_drink.global_position = Vector2(500, 500)
		new_drink.attached_drink.parent_snake = null
	return new_drink

## Not sure how removing snakes will work
func remove_snake(snake: Snake) -> void:
	snake_deck.erase(snake)
	tooltip_manager.remove_item(snake, true)
	_open_slot_inds.push_back(snake.deck_index)
	
	_current_count.set_value(snake_deck.size())

## Idk where we want the animation to be placed (if we have one?)
func add_snake(new_snake: Snake) -> void:
	snake_deck.push_back(new_snake)
	
	var ind = _open_slot_inds.pick_random()
	_open_slot_inds.erase(ind)
	new_snake.deck_index = ind
	
	new_snake.position = _all_slots[ind]
	
	tooltip_manager.add_item(new_snake)
	
	_current_count.set_value(snake_deck.size())
	pass

func shuffle_drawpile() -> void:
	drink_drawpile.shuffle()
	pass

func return_to_drawpile(og_drink: DrinkResource, cur_drink: DrinkResource):
	var new_drink: Drink = create_drink(cur_drink, og_drink, null)
	drink_drawpile.push_back(new_drink)
	tooltip_manager.add_item(new_drink)
	shuffle_drawpile()
	pass

func _child_clicked(child: DeckItem) -> void:
	if child is Snake:
		snake_chosen.emit(child)
	return

func _refill_animation() -> void:
	var t = create_tween().set_parallel().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	
	for s: Snake in snake_deck:
		var new_drop = Sprite2D.new()
		new_drop.texture = _venom_drop_texture
		new_drop.modulate = s.attached_snake.poison_color
		new_drop.position = s.position + Vector2(0, 50)
		new_drop.scale = Vector2.ONE * 1.75
		_venom_drops.add_child(new_drop)
		var end_location = s.position + Vector2(0, 150)
		t.tween_property(new_drop, "position", end_location, 0.2)
	
	await t.finished
	
	for d in _venom_drops.get_children(): d.queue_free()
