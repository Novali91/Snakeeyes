class_name GameStats
extends Node

const HAND_SIZE: int = 30
const SCREEN_SIZE: Vector2 = Vector2(1920, 1080)
const ANTIDOTE_COST: int = 2

var turn_count: int = 0

signal poison_set(old_val: int, new_val: int)
var _poison: int

signal strength_set(old_val: int, new_val: int)
var _strength: int

signal charm_set(old_val: int, new_val: int)
var _charm: int

signal score_set(old_val: int, new_val: int)
var _score: int

signal antidote_num_set(old_val: int, new_val: int)
var _antidote_num: int

func set_poison(val: int) -> void:
	poison_set.emit(_poison, val)
	_poison = val

func get_poison() -> int:
	return _poison

func set_strength(val: int) -> void:
	strength_set.emit(_strength, val)
	_strength = val

func get_strength() -> int:
	return _strength

func set_charm(val: int) -> void:
	charm_set.emit(_charm, val)
	_charm = val

func get_charm() -> int:
	return _charm

func set_score(val: int) -> void:
	score_set.emit(_charm, val)
	_score = val

func get_score() -> int:
	return _score

func set_antidote_num(val: int) -> void:
	antidote_num_set.emit(_antidote_num, val)
	_antidote_num = val

func get_antidote_num() -> int:
	return _antidote_num

################################################################################

var starting_snakes: Array[SnakeResource] = [
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/red_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/red_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/blue_viper.tres"),
]

var common_snakes: Array[SnakeResource] = [
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/python.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/tiger_keelback.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/placeboa.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/short_boa.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/long_boa.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/garden_snake.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/clairvoyant_snake.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/ambush_viper.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/cannibal_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/hydra.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/friendly_snake.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/familiar_snake.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/charming_snake.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/asclepius_snake.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/king_cobra.tres"),
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/str_per_anti.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/ouroboros.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/quetzalcoatl.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/gorgon_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/jormungandr.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/black_mamba.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/basilisk.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/scarlet_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/ball_python.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/caduceus_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/coral_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/hognose_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/parrot_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/str_per_anti.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/rainboa.tres"),
	
]

var rare_snakes: Array[SnakeResource] = [
	
]

var legendary_snakes: Array[SnakeResource] = [
	
]

var attack_array: Array[PackedInt64Array] = [
	[1],
	[2],
	[1, 1],
	[2],
	[4],
	[1, 2],
	[5],
	[1, 1, 1],
	[1],
	[4, 1, 1],
	[1, 5],
	[3, 4],
	[2],
	[2, 2, 5],
	[4, 4, 1],
	[1, 1, 7],
	[5],
	[1, 1, 1, 1, 1, 1, 1, 1, 1],
	[10],
	[5, 5, 5],
	[4],
	[12, 2, 2],
	[8, 5],
	[14],
	[2],
	[5, 5, 5, 5, 5],
	[12],
	[2, 2, 12, 2],
	[99999999],
	[99999999],
	[99999999],
	[99999999],
	[99999999],
	[99999999],
	[99999999],
	[99999999],
	[99999999],
	[99999999],
	[99999999],
	[99999999]
]

var sound_manager: SoundManager
