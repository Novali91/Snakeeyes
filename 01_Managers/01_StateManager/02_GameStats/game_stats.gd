class_name GameStats
extends Node

const HAND_SIZE: int = 10
const SCREEN_SIZE: Vector2 = Vector2(1920, 1080)

var poison: int
var strength: int
var charm: int
var score: int
var antidote_num: int

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
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/green_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/red_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/blue_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/python.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/tiger_keelback.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/placeboa.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/short_boa.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/long_boa.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/garden_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/clairvoyant_snake.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/ambush_viper.tres"),
	load("res://02_Deck/02_Snakes/01_SpecificSnakes/cannibal_snake.tres")
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
	[3],
	[1, 2],
	[4],
	[2, 2],
	[4],
	[2, 2],
	[4],
	[2, 2],
	[4],
	[2, 2],
	[4],
	[2, 2],
	[4],
	[2, 2],
	[4],
	[2, 2],
]
