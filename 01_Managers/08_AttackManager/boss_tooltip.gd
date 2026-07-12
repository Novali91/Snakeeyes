class_name BossTooltip
extends Node2D

@onready var attack_description: RichTextLabel = $AttackDescription
#@onready var turn: RichTextLabel = $Turn
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

func hover_tooltip(upcoming_index: int, turn_number: int) -> void:
	## Will do some opacity tweening
	activate_boss_attack_tooltip(upcoming_index, turn_number)
	
	if _cur_tween != null:
		_cur_tween.kill()
	
	var tween: Tween = create_tween()
	_cur_tween = tween
	
	tween.parallel().tween_property(attack_sprite, "modulate:a", 0.1, 0.5)
	tween.parallel().tween_property(attack_description, "modulate:a", 0.1, 0.5)
	tween.parallel().tween_property(attack_description.material, "shader_parameter/color", Color(1, 1, 1, 0.8), 0.5)
	tween.parallel().tween_property(attack_sprite.material, "shader_parameter/color", Color(0, 0, 0, 0.7), 0.5)
	
	return

func unhover_tooltip() -> void:
	if _cur_tween != null:
		_cur_tween.kill()
	
	var tween: Tween = create_tween()
	_cur_tween = tween
	
	tween.parallel().tween_property(attack_sprite, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(attack_description, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(attack_description.material, "shader_parameter/color", Color(1, 1, 1, 0.0), 0.5)
	tween.parallel().tween_property(attack_sprite.material, "shader_parameter/color", Color(0, 0, 0, 0.0), 0.5)
	return

func start_boss_round(upcoming_index: int, turn_number: int) -> void:
	activate_boss_attack_tooltip(upcoming_index, turn_number)
	
	if _cur_tween != null:
		_cur_tween.kill()
	
	var tween: Tween = create_tween()
	_cur_tween = tween
	
	tween.parallel().tween_property(attack_sprite, "modulate:a", 0.1, 0.5)
	tween.parallel().tween_property(attack_description, "modulate:a", 0.1, 0.5)
	tween.parallel().tween_property(attack_description.material, "shader_parameter/color", Color(1, 1, 1, 1.0), 0.5)
	tween.parallel().tween_property(attack_sprite.material, "shader_parameter/color", Color(0, 0, 0, 1.0), 0.5)
	await get_tree().create_timer(1.5).timeout
	_flash_red(10)
	return

## I imagine attack_manager will call this on the drink being hovered?
func activate_boss_attack_tooltip(upcoming_index: int, turn_number: int) -> void:
	var string_to_set: String = get_description(upcoming_index)
	
	#regular_sprite.visible = false
	#convo.visible = false
	
	attack_description.push_bold()
	attack_description.push_font_size(40)
	
	match turn_number:
		0:
			attack_description.text = "This turn..."
		1:
			attack_description.text = "Next turn..."
		_:
			attack_description.text = "In "
			attack_description.text += str(turn_number)
			attack_description.text += " turns..."
	attack_description.pop_all()
	
	attack_description.text += "\n\n"
	attack_description.text += string_to_set
	attack_sprite.visible = true
	attack_description.visible = true
	pass

## Whenever the boss attack round ends
func deactivate_boss_attack_tooltip() -> void:
	#if _cur_tween != null:
		#_cur_tween.kill()
	#
	#var tween: Tween = create_tween()
	#_cur_tween = tween
	#
	#tween.parallel().tween_property(attack_sprite, "modulate:a", 0.0, 0.5)
	#tween.parallel().tween_property(attack_description, "modulate:a", 0.0, 0.5)
	
	attack_description.modulate.a = 0
	attack_description.material.set_shader_parameter(
		"color",
		Color(1, 1, 1, 0)
	)
	attack_sprite.modulate.a = 0
	attack_sprite.material.set_shader_parameter(
		"color",
		Color(0, 0, 0, 0)
	)
	
	pass

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
			string_to_set = "I will EAT whichever sssnakesss produced the venom that you leave on the table..."
		7:
			string_to_set = "Poison becomess charm, and charm becomes poison...."
		8:
			string_to_set = "Whenever you drink a concoction, the sssnake that produced it will become ssslightly more venomousss..."
		9:
			string_to_set = "All diccce will roll one lessss...."
		10:
			string_to_set = "If you beat me, you will win... If you do not, we continue until you or I perish..."
		_:
			string_to_set = "I like snakesss... not BUGSSS!!!"
	return string_to_set

func _flash_red(num: int) -> void:
	for i in range(num):
		attack_sprite.material.set_shader_parameter(
		"color",
		Color(.9, .1, .1, 1)
		)
		await get_tree().create_timer(.25).timeout
		attack_sprite.material.set_shader_parameter(
		"color",
		Color(0, 0, 0, 1)
		)
		await get_tree().create_timer(.25).timeout
	return
## Each turn it will pick a random one of these, maybe at start of turn?
#func pick_convo_string() -> String:
	#if GS.turn_count == 0: return "Hover here to see an upcoming attack..."
	#
	#return array_of_convo.pick_random()
