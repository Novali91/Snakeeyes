class_name ShopManager
extends Node2D

const SHOP_SIZE: int = 5

signal snake_clicked(snake: Snake)

var can_buy: bool = false

@onready var _tooltip_manager: TooltipManager = $TooltipManager

@onready var _snake_scene: PackedScene = preload("res://02_Deck/02_Snakes/snake.tscn")

var _starting_snakes: Array[SnakeResource] = [
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
]

var _common_snakes: Array[SnakeResource] = [
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres")
]

var _rare_snakes: Array[SnakeResource]

var _legendary_snakes: Array[SnakeResource]

var _shop_positions: Array[Vector2] = [
	Vector2(300, 1080 / 2.),
	Vector2(600, 1080 / 2.),
	Vector2(900, 1080 / 2.),
	Vector2(1200, 1080 / 2.),
	Vector2(1500, 1080 / 2.)
]

var _cur_snakes: Array[Snake] = []

func _ready() -> void:
	_tooltip_manager.child_was_clicked.connect(_snake_clicked)

func empty_shop() -> void:
	pass

func fill_shop() -> void:
	_cur_snakes = _get_snakes(SHOP_SIZE)
	for i in SHOP_SIZE:
		_cur_snakes[i].position = _shop_positions[i]
		_tooltip_manager.add_item(_cur_snakes[i])

func get_starting_snakes() -> Array[Snake]:
	var snake_arr: Array[Snake] = []
	
	for s: SnakeResource in _starting_snakes:
		var new_snake = _create_snake(s)
		snake_arr.push_back(new_snake)
	
	return snake_arr

func _get_snakes(num: int) -> Array[Snake]:
	var arr: Array[Snake] = []
	
	for i in num:
		var new_snake = _create_snake(_common_snakes[0])
		arr.push_back(new_snake)
	
	return arr

func _snake_clicked(snake: DeckItem) -> void:
	if not can_buy: return
	
	var typed_snake = snake as Snake
	snake_clicked.emit(typed_snake)

func _purchase_snake(snake: Snake) -> void:
	pass

func _create_snake(resource: SnakeResource) -> Snake:
	var new_snake: Snake = _snake_scene.instantiate()
	new_snake.attached_snake = resource
	new_snake.current_drink = resource.drink_resource.duplicate()
	return new_snake
