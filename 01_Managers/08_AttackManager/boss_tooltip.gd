class_name BossTooltip
extends Node2D

@onready var attack_description: RichTextLabel = $AttackDescription
@onready var turn: RichTextLabel = $Turn
@onready var regular_sprite: Sprite2D = $RegularSprite
@onready var convo: RichTextLabel = $Convo
@onready var attack_sprite: Sprite2D = $AttackSprite

## Used for random conversation
var array_of_convo: Array[String] = [
	"SSSNAKE BINGO!",
	"...",
	"I love my sssnakesss...",
	"Prepare for defeat...",
	"A cccircccle? Ohhh... You mean a pi-thon...",
	"How absssolutely venomousss....",
	"Where is everyone? Ssssnake bingo?",
	"Have you met my friendssss yet?",
	"If you pay the price, I shall show you new wares.",
	"Conniving I may be, but I fight fair."
]

var cur_string: String
## I imagine attack_manager will call this on the drink being hovered?
func activate_boss_attack_tooltip(upcoming_index: int, turn_number: int) -> void:
	var string_to_set: String = get_description(upcoming_index)
	
	regular_sprite.visible = false
	convo.visible = false
	
	attack_description.text = string_to_set
	turn.text = "In "
	turn.push_bold()
	turn.push_font_size(40)
	turn.text += str(turn_number)
	turn.text += " turns..."
	turn.pop_all()
	
	turn.visible = true
	attack_sprite.visible = true
	attack_description.visible = true
	pass

## Whenever the drink is unhovered?
func deactivate_boss_attack_tooltip() -> void:
	turn.visible = false
	attack_description.visible = false
	attack_sprite.visible = false
	
	convo.text = cur_string
	convo.visible = true
	regular_sprite.visible = true
	pass

#const EXACT_SCORE: int = 1 # X
#const DRINK_ALL_DRINKS_MINUS_STR: int = 2 # X
#const SWAP_CHARM_STR: int = 3 # X
#const DRINK_DRAW_ONE: int = 4 # X
#const DRINK_SLIDE_BACK: int = 5 # X
#const END_KILL_SNAKES: int = 6 # X
#const SWAP_POISON_CHARM: int = 7 # X
#const DRINK_SNAKE_ONE_POISON: int = 8  # X
#const DICE_ROLLS_MINUS_ONE: int = 9 # X
#const WIN_ROUND: int = 10 # X

func get_description(upcoming: int) -> String:
	var string_to_set: String
	match upcoming:
		1:
			string_to_set = "You mussst match my ssstrength exxxxactly...."
		2:
			string_to_set = "When you drink a concoction, your other concoctionsss on the table will grow weaker..."
		3:
			string_to_set = "Charm becomesss ssstrength, and ssstrength becomesss charm..."
		4:
			string_to_set = "When you drink a concoction, sssslide another one in...."
		5:
			string_to_set = "When you drink a concoction, ssslide one back..."
		6:
			string_to_set = "I will EAT whichever sssnakesss produced the venom that you leave on the table and do not drink..."
		7:
			string_to_set = "Poissson becomess charm, and charm becomesss poisson...."
		8:
			string_to_set = "Whenever you drink a concoction, the sssnake that produced it will become slightly more venomousss..."
		9:
			string_to_set = "All diccce will roll one lessss...."
		10:
			string_to_set = "If you beat me, you will win... If you do not, we continue until you or I perish..."
	return string_to_set


## Each turn it will pick a random one of these, maybe at start of turn?
func pick_convo_string() -> String:
	if GS.turn_count == 0: return "Hover here to see an upcoming attack..."
	
	return array_of_convo.pick_random()
