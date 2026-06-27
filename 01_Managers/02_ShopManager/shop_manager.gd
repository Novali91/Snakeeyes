class_name ShopManager
extends Node2D

const SHOP_SIZE: int = 5

const L_CHANCE_PER_SLOT: float = 0.04
const R_CHANCE_PER_SLOT: float = 0.27

signal snake_clicked(snake: Snake)
signal antidote_clicked()
signal reroll_clicked()
signal exit_shop_clicked()

var can_buy: bool = false
var antidote_position: Vector2

@onready var _tooltip_manager: TooltipManager = $TooltipManager
@onready var ability_helper: ShopAbilityHelper = $ShopAbilityHelper
@onready var _labels_node: Node2D = $PriceLabels
@onready var _antidote_button: Button = $AntidoteButton
@onready var _open_sign: AnimatedSprite2D = $OpenSign
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _exit_button: Button = $OpenSign/ExitButton
@onready var _reroll_sign: Sprite2D = $Reroll

@onready var _snake_scene: PackedScene = preload("res://02_Deck/02_Snakes/snake.tscn")
@onready var _markers_node: Node2D = $Markers

@onready var reroll_button: Button = $RerollButton
@onready var antidote: Sprite2D = $Antidote
@onready var _reroll_cost: CustomNumber = $RerollButton/CustomNumber
@onready var _reroll_player: AnimationPlayer = $RerollButton/AnimationPlayer

var _actual_parrot: SnakeResource

var _shop_positions: Array[Vector2]

var _cur_snakes: Array[Snake] = []
var _labels: Array[CustomNumber] = []
var antidote_stock: int = 0

var first_stock_tutorial: bool = true

func _ready() -> void:
	ability_helper.shop_manager = self
	_tooltip_manager.child_was_clicked.connect(_snake_clicked)
	_antidote_button.pressed.connect(_antidote_clicked)
	_exit_button.pressed.connect(_click_open_sign)
	_exit_button.mouse_entered.connect(_hover_open_sign)
	_exit_button.mouse_exited.connect(_unhover_open_sign)
	reroll_button.pressed.connect(_reroll_pressed)
	reroll_button.mouse_entered.connect(_reroll_hovered)
	reroll_button.mouse_exited.connect(_reroll_unhovered)
	_antidote_button.mouse_entered.connect(_antidote_hovered)
	_antidote_button.mouse_exited.connect(_antidote_unhovered)
	
	_reroll_sign.material.set_shader_parameter("color", Color(1.0, 0.5, 0.65, 1.0))
	
	for l: CustomNumber in _labels_node.get_children():
		_labels.push_back(l)
	
	antidote_position = _antidote_button.global_position + Vector2(188 / 2., 0)
	
	var _parrot_resource: SnakeResource = load("res://02_Deck/02_Snakes/01_SpecificSnakes/parrot_snake.tres")
	_actual_parrot = _parrot_resource.duplicate()
	
	_shop_positions = []
	for m: Marker2D in _markers_node.get_children():
		_shop_positions.push_back(m.position)

func empty_shop() -> void:
	var arr_copy = _cur_snakes.duplicate()
	for s: Snake in arr_copy:
		_remove_snake(s)

func fill_shop() -> void:
	var cur_snake_resources: Array[SnakeResource] = _get_snakes(SHOP_SIZE)
	for snake: SnakeResource in cur_snake_resources:
		_cur_snakes.append(create_snake(snake))
	
	for i in SHOP_SIZE:
		_cur_snakes[i].position = _shop_positions[i]
		_labels[i].set_value(_cur_snakes[i].attached_snake.cost)
		_tooltip_manager.add_item(_cur_snakes[i])

func toggle_open(open: bool) -> void:
	can_buy = open
	if open:
		_animation_player.play("brighten")
	
	else:
		_animation_player.play("darken")

func stock_antidote() -> void:
	antidote_stock = 1
	antidote.visible = true

func get_starting_snakes() -> Array[Snake]:
	var snake_arr: Array[Snake] = []
	
	for s: SnakeResource in GS.starting_snakes:
		var new_snake = create_snake(s)
		snake_arr.push_back(new_snake)
	
	return snake_arr

func create_snake(resource: SnakeResource) -> Snake:
	var new_snake: Snake = _snake_scene.instantiate()
	new_snake.attached_snake = resource
	if (resource.drink_resource.special_ability == 23):
		new_snake.current_drink = _actual_parrot.drink_resource
	else:
		new_snake.current_drink = resource.drink_resource.duplicate()
	return new_snake

func purchase_snake(snake: Snake) -> void:
	_remove_snake(snake)

func purchase_antidote() -> void:
	antidote_stock -= 1
	if antidote_stock <= 0:
		antidote.visible = false

func _get_snakes(num: int) -> Array[SnakeResource]:
	var arr: Array[SnakeResource] = []
	var chance: float
	var new_snake: SnakeResource = null
	for i in num:
		chance = randf()
		if chance <= L_CHANCE_PER_SLOT:
			while new_snake in arr or new_snake == null:
				new_snake = GS.legendary_snakes.pick_random()
		elif chance <= R_CHANCE_PER_SLOT+L_CHANCE_PER_SLOT:
			while new_snake in arr or new_snake == null:
				new_snake = GS.rare_snakes.pick_random()
		else:
			while new_snake in arr or new_snake == null:
				new_snake = GS.common_snakes.pick_random()
		
		arr.push_back(new_snake)
	
	if GS.tutorial_index == GS.Tutorial.START and first_stock_tutorial:
		first_stock_tutorial = false
		arr = [
			GS.common_snakes[0],
			GS.common_snakes[1],
			GS.common_snakes[2],
			GS.common_snakes[3],
			GS.rare_snakes[5]
		]
	
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

func _hover_open_sign() -> void:
	if not can_buy: return
	_open_sign.material.set_shader_parameter("color", Color(1.0, 0.921, 0.41, 1.0))

func _unhover_open_sign() -> void:
	_open_sign.material.set_shader_parameter("color", Color(1.0, 0.5, 0.65, 1.0))

func _click_open_sign() -> void:
	if not can_buy: return
	exit_shop_clicked.emit()

#func _hover_reroll() -> void:
	#if not can_buy: return
	#_reroll_sign.material.set_shader_parameter("color", Color(1.0, 0.921, 0.41, 1.0))
#
#func _unhover_reroll() -> void:
	#_reroll_sign.set_shader_parameter("color", Color(1.0, 0.5, 0.65, 1.0))

############ UGLY NEED FIX??

func _reroll_pressed() -> void:
	if not can_buy: return
	reroll_clicked.emit()

func update_reroll(cost: int) -> void:
	_reroll_cost.set_value(cost)
	_reroll_player.play("reroll")

func _reroll_hovered() -> void:
	if not can_buy: return
	_reroll_sign.material.set_shader_parameter("color", Color(1.0, 0.921, 0.41, 1.0))

func _reroll_unhovered() -> void:
	_reroll_sign.material.set_shader_parameter("color", Color(1.0, 0.5, 0.65, 1.0))

func _antidote_hovered() -> void:
	antidote.material.set_shader_parameter("color", Color(1.0, 0.921, 0.41, 1.0))

func _antidote_unhovered() -> void:
	antidote.material.set_shader_parameter("color", Color("ff94fa"))
