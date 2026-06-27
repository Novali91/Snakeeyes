class_name BossTooltip
extends Node2D

@onready var attack_description: RichTextLabel = $AttackDescription
@onready var turn: RichTextLabel = $Turn
#@onready var regular_sprite: Sprite2D = $RegularSprite
#@onready var convo: RichTextLabel = $Convo
@onready var attack_sprite: Sprite2D = $AttackSprite

 ## For tweening the opacity of the textbox
## How it works: When hovered, it will start a tween
## When unhovered, it will start a tween
## However, in either case, if _cur_tween is not null, it will first end that tween
var _cur_tween: Tween

## Used for random conversation
#var array_of_convo: Array[String] = [
	#"SSSNAKE BINGO!",
	#"...",
	#"I love my sssnakesss...",
	#"Prepare for defeat...",
	#"A cccircccle? Ohhh... You mean a pi-thon...",
	#"How absssolutely venomousss....",
	#"Where is everyone? Ssssnake bingo?",
	#"Have you met my friendssss yet?",
	#"If you pay the price, I shall show you new wares.",
	#"Conniving I may be, but I fight fair."
#]

var cur_string: String

func hover_tooltip(upcoming_index: int, turn_number: int) -> void:
	## Will do some opacity tweening
	activate_boss_attack_tooltip(upcoming_index, turn_number)
	
	if _cur_tween != null:
		_cur_tween.kill()
	
	var tween: Tween = create_tween()
	_cur_tween = tween
	
	tween.parallel().tween_property(attack_sprite, "modulate:a", 0.5, 0.5)
	tween.parallel().tween_property(turn, "modulate:a", 0.5, 0.5)
	tween.parallel().tween_property(attack_description, "modulate:a", 0.5, 0.5)
	
	return

func unhover_tooltip() -> void:
	
	if _cur_tween != null:
		_cur_tween.kill()
	
	var tween: Tween = create_tween()
	_cur_tween = tween
	
	tween.parallel().tween_property(attack_sprite, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(turn, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(attack_description, "modulate:a", 0.0, 0.5)
	
	return

func start_boss_round(upcoming_index: int, turn_number: int) -> void:
	## Disable the hover/unhover stuff, but that might be better to do in attack_manager?
	## Or maybe just a boolean in boss tooltip that this turns false and-
	## -deactivate_boss_attack_tooltip sets to true? - This is probably bad; don't want this script doing logic like that
	
	## Then, tween opacity of textbox to 1.0 and someehow type in the text
	return

## I imagine attack_manager will call this on the drink being hovered?
func activate_boss_attack_tooltip(upcoming_index: int, turn_number: int) -> void:
	var string_to_set: String = get_description(upcoming_index)
	
	#regular_sprite.visible = false
	#convo.visible = false
	
	
	if turn_number > 1:
		turn.text = "In "
		turn.push_bold()
		turn.push_font_size(40)
		turn.text += str(turn_number)
		turn.text += " turns..."
		turn.pop_all()
	elif turn_number == 1:
		turn.push_bold()
		turn.push_font_size(40)
		turn.text += "Next turn..."
		turn.pop_all()
	else:
		turn.text = "This turn..."
		turn.push_bold()
		turn.push_font_size(40)
		turn.pop_all()
	attack_description.text = string_to_set
	turn.visible = true
	attack_sprite.visible = true
	attack_description.visible = true
	pass

## Whenever the boss attack round ends
func deactivate_boss_attack_tooltip() -> void:
	## Probably tween to opacity zero again
	turn.visible = false
	attack_description.visible = false
	attack_sprite.visible = false
	
	#convo.text = cur_string
	#convo.visible = true
	#regular_sprite.visible = true
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
			string_to_set = "Poison becomess charm, and charm becomes poison...."
		8:
			string_to_set = "Whenever you drink a concoction, the sssnake that produced it will become ssslightly more venomousss..."
		9:
			string_to_set = "All diccce will roll one lessss...."
		10:
			string_to_set = "If you beat me, you will win... If you do not, we continue until you or I perish..."
	return string_to_set


## Each turn it will pick a random one of these, maybe at start of turn?
#func pick_convo_string() -> String:
	#if GS.turn_count == 0: return "Hover here to see an upcoming attack..."
	#
	#return array_of_convo.pick_random()
