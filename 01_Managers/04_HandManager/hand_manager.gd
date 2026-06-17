class_name HandManager
extends Node2D

const _SPAM_TIMEOUT: float = 0.05

signal hand_empty()

var _spam_timer: float = 0

var drinks: Array[Drink]

@onready var tooltip_manager: TooltipManager = $TooltipManager
@onready var slide_manager: SlideManager = $SlideManager
@onready var ability_helper: HandAbilityHelper = $HandAbilityHelper

var drinks_drinkable: bool = true

## For when a drink is drinkable and is clicked (play state connected to this)
signal drink_drank(resource: DrinkResource, drink_position: Vector2, og_resource: DrinkResource)
## For when a drink is not drinkable and is clicked (hand_ability_helper maybe connected)
signal drink_chosen(drink: Drink)

var drinks_drank: int

func _ready() -> void:
	tooltip_manager.child_was_clicked.connect(_click_drink)
	slide_manager.delete_after_slide.connect(_delete_drink)

func _process(delta: float) -> void: _spam_timer -= delta

func get_num_drinks() -> int:
	return drinks.size()


## Bug: For some reason this is called twice? Is that normal?
func draw_drinks(new_drinks: Array[Drink]) -> void:
	for drink in new_drinks:
		drink.visible = false
		tooltip_manager.add_item(drink)
		drinks.append(drink)
	slide_manager.slide_drinks(new_drinks)

func _click_drink(drink: Drink) -> void:
	if _spam_timer > 0: return
	
	if !drinks_drinkable:
		drink_chosen.emit(drink)
		return
	
	_spam_timer = _SPAM_TIMEOUT
	
	remove_drink(drink)
	GS.sound_manager.play_gulp()
	drink_drank.emit(drink.attached_drink, drink.global_position, drink.attached_drink_resource)
	drinks_drank += 1
	# Bandaid fix
	if drink.attached_drink.special_ability != 17:
		tooltip_manager.remove_item(drink, true)
	else:
		ability_helper.slide_drink_back(drink)
	
	if drinks.size() == 0: hand_empty.emit()

func _delete_drink(drink: Drink) -> void:
	remove_drink(drink)
	tooltip_manager.remove_item(drink, true)

func remove_drink(drink_to_remove: Drink) -> void:
	slide_manager.free_endpoint(drink_to_remove)
	drinks.erase(drink_to_remove)

func end_turn_discard() -> void:
	var temp_drink: Drink
	var kill_snake: bool = false
	
	for i: int in range(drinks.size() -1, -1, -1):
		if drinks[i] is Drink:
			temp_drink = drinks[i]
			if temp_drink.attached_drink.retain == false: ## Test retain
				slide_manager.free_endpoint(temp_drink)
				tooltip_manager.remove_item(temp_drink, true)
				drinks.erase(temp_drink)
	
	drinks_drank = 0

func _clear_drinks() -> void:
	for i: int in range(drinks.size() - 1, -1, -1):
		if drinks[i].attached_drink.retain == false:
			slide_manager.free_endpoint(drinks[i])
			drinks.remove_at(i)
