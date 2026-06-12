class_name ShopManager
extends Node2D

const SHOP_SIZE: int = 5

signal snake_clicked(snake: Snake)
signal antidote_clicked()

var can_buy: bool = false
var antidote_position: Vector2

@onready var _tooltip_manager: TooltipManager = $TooltipManager
@onready var ability_helper: ShopAbilityHelper = $ShopAbilityHelper
@onready var _labels_node: Node2D = $PriceLabels
@onready var _antidote_button: Button = $AntidoteButton
@onready var darkness: ColorRect = $Darkness

@onready var _snake_scene: PackedScene = preload("res://02_Deck/02_Snakes/snake.tscn")

var _shop_positions: Array[Vector2] = [
	Vector2(300, 1080 / 2.),
	Vector2(600, 1080 / 2.),
	Vector2(900, 1080 / 2.),
	Vector2(1200, 1080 / 2.),
	Vector2(1500, 1080 / 2.)
]

var _cur_snakes: Array[Snake] = []
var _labels: Array[Label] = []
var antidote_stock: int = 0

func _ready() -> void:
	ability_helper.shop_manager = self
	_tooltip_manager.child_was_clicked.connect(_snake_clicked)
	_antidote_button.pressed.connect(_antidote_clicked)
	
	for l: Label in _labels_node.get_children():
		_labels.push_back(l)
	
	antidote_position = _antidote_button.global_position + Vector2(188 / 2., 0)

func empty_shop() -> void:
	var arr_copy = _cur_snakes.duplicate()
	for s: Snake in arr_copy:
		_remove_snake(s)

func fill_shop() -> void:
	_cur_snakes = _get_snakes(SHOP_SIZE)
	for i in SHOP_SIZE:
		_cur_snakes[i].position = _shop_positions[i]
		_labels[i].text = str(_cur_snakes[i].attached_snake.cost)
		_tooltip_manager.add_item(_cur_snakes[i])
	
	antidote_stock = 1

func get_starting_snakes() -> Array[Snake]:
	var snake_arr: Array[Snake] = []
	
	for s: SnakeResource in GS.starting_snakes:
		var new_snake = create_snake(s)
		snake_arr.push_back(new_snake)
	
	return snake_arr

func create_snake(resource: SnakeResource) -> Snake:
	var new_snake: Snake = _snake_scene.instantiate()
	new_snake.attached_snake = resource
	new_snake.current_drink = resource.drink_resource.duplicate()
	return new_snake

func purchase_snake(snake: Snake) -> void:
	_remove_snake(snake)

func purchase_antidote() -> void:
	antidote_stock -= 1

func _get_snakes(num: int) -> Array[Snake]:
	var arr: Array[Snake] = []
	
	for i in num:
		var new_snake = create_snake(GS.common_snakes.pick_random())
		arr.push_back(new_snake)
	
	return arr

func _snake_clicked(snake: DeckItem) -> void:
	if not can_buy: return
	
	var typed_snake = snake as Snake
	snake_clicked.emit(typed_snake)

func _antidote_clicked() -> void:
	if not can_buy: return
	if antidote_stock <= 0: return
	antidote_clicked.emit()

func _remove_snake(snake: Snake) -> void:
	_cur_snakes.erase(snake)
	_tooltip_manager.remove_item(snake, true)
