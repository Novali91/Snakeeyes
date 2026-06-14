class_name GameStats
extends Node

const HAND_SIZE: int = 500
const SCREEN_SIZE: Vector2 = Vector2(1920, 1080)
const ANTIDOTE_COST: int = 2
const MAX_LIVES: int = 6

const RARITY_TO_COLOR: Dictionary[String, Color] = {
	"S": Color(1.0, 0.83, 0.83, 1.0),
	"C": Color(1.0, 0.83, 0.83, 1.0),
	"R": Color(0.46, 0.973, 1.0, 1.0),
	"L": Color(0.95, 1.0, 0.0, 1.0),
}

var in_tutorial: bool = true

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

var cur_attack_index: int = 0

func set_poison(val: int) -> void:
	var clamped = clamp(val, 1, 13)
	_poison = clamped
	poison_set.emit(_poison, clamped)
	

func get_poison() -> int:
	return _poison

func set_strength(val: int) -> void:
	var clamped = clamp(val, 0, 999)
	_strength = clamped
	strength_set.emit(_strength, clamped)

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

## Bandaid fix but we know how we could've made the code better if we weren't cutting corners so it doesn't matter (sorry I'm a chud :()
var hand_manager: HandManager

################################################################################

var starting_snakes: Array[SnakeResource] = [
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/red_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/red_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/blue_viper.tres"),
]

var common_snakes: Array[SnakeResource] = [
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/tiger_keelback.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/placeboa.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/short_boa.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/garden_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/ambush_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/asclepius_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/scarlet_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/hognose_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/parrot_snake.tres")
	#load("res://02_Deck/02_Snakes/01_SpecificSnakes/long_boa.tres"), Removed
	# load("res://02_Deck/02_Snakes/01_SpecificSnakes/familiar_snake.tres"), Removed
]

var rare_snakes: Array[SnakeResource] = [
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/cannibal_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/friendly_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/king_cobra.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/str_per_anti.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/gorgon_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/black_mamba.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/basilisk.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/rainboa.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/ball_python.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/coral_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/charming_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/python.tres"),
]

var legendary_snakes: Array[SnakeResource] = [
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/clairvoyant_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/hydra.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/ouroboros.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/quetzalcoatl.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/caduceus_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/jormungandr.tres")
]

var sound_manager: SoundManager
