class_name TutorialManager
extends CanvasLayer

@onready var _ap: AnimationPlayer = $AnimationPlayer
@onready var _fade_p: AnimationPlayer = $FadePlayer
@onready var _tb: TextBox = $TextBox


func start_of_turn_one() -> void:
	print("start_of_turn_one")
	
	##
	_tb.global_position = $Markers/Center.global_position
	
	_tb.text_array = [
		"Sssit down dear...",
		"We will play a sssimple drinking game."
	]
	_tb.open()
	
	await _tb.clicked_close
	
	##
	_ap.play("strength")
	_open()
	
	_tb.text_array = [
		"This meter will measure your ssstrength!"
	]
	_tb.update()
	
	await _tb.clicked_close
	
	##
	_ap.play("tickers")
	
	_tb.text_array = [
		"Each round I will drink a venom and set your ssstrength goal...",
	]
	_tb.update()
	
	await _tb.clicked_close
	
	##
	_tb.global_position = $Markers/Center.global_position
	
	_ap.play("lives")
	
	_tb.text_array = [
		"If you fail to meet or exceed the goal, I will sssubtract one of your lives...",
		"Don't look ssso mortified... I am not a cruel missstresss...",
		"If you manage to sssucceed, I will allow you to regain a life."
	]
	_tb.update()
	
	await _tb.clicked_close
	
	##
	_tb.global_position = $Markers/TopRight.global_position
	
	_ap.play("drinks")
	
	_tb.text_array = [
		"To gain ssstrength you will drink venoms...",
	]
	_tb.update()
	
	await _tb.clicked_close
	
	##
	_ap.play("drink_strength")
	
	_tb.text_array = [
		"Sssome venoms will only increase your ssstrength..."
	]
	_tb.update()
	
	await _tb.clicked_close
	
	##
	_ap.play("drink_charm")
	
	_tb.text_array = [
		"Othersss will give you charm for new sssnakes."
	]
	_tb.update()
	
	await _tb.clicked_close
	
	##
	_tb.global_position = $Markers/Center.global_position
	
	_ap.play("poison")
	
	_tb.text_array = [
		"But do not be a fool dear...",
		"Ingesting venomsss is poisonousss...",
		"The more you drink, the higher the chance you passs out."
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_close()
	
	_tb.text_array = [
		"For now, sssimply drink all the venomsss on the table."
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_tb.close()

func drinks_drunk() -> void:
	print("drinks_drunk")
	
	_tb.global_position = $Markers/Center.global_position
	
	_ap.play("bell")
	_open()
	
	_tb.text_array = [
		"To tell me you are finished ring the bell.",
	]
	_tb.open()
	
	await _tb.clicked_close
	await _close()
	_tb.close()


func end_turn_pressed() -> void:
	print("end_turn_pressed")
	
	_tb.global_position = $Markers/Center.global_position
	
	_tb.text_array = [
		"Now to see if you passs out... we will roll the dice...",
	]
	_tb.open()
	
	await _tb.clicked_close
	
	await _tb.close()


func dice_rolled() -> void:
	print("dice_rolled")
	
	await get_tree().create_timer(0.5).timeout
	
	_tb.global_position = $Markers/TopRight.global_position
	
	_tb.text_array = [
		"Sssnake eyesss...",
		"...",
		"Since you rolled lower than your poissson, normally you would passss out...",
		"And you would lose all your ssstrength and charm...",
		"However... my players start with an antidote...",
		"Each antidote will let you reroll the dice."
	]
	_tb.open()
	
	await _tb.clicked_close
	_tb.close()

func compare_strength() -> void:
	print("compare_strength")
	
	_tb.global_position = $Markers/Center.global_position
	
	_tb.text_array = [
		"Now lets sssee your strength dear..."
	]
	_tb.open()
	
	await _tb.clicked_close
	_tb.close()

func entered_shop() -> void:
	print("entered_shop")
	
	await get_tree().create_timer(0.75).timeout
	
	_tb.global_position = $Markers/Center.global_position
	
	_tb.text_array = [
		"What a rush!",
		"...",
		"Sssee these sssnakesss?",
		"You may spend your charm to add them to your collection...",
	]
	_tb.open()
	
	await _tb.clicked_close
	
	_ap.play("shop_snake")
	_open()
	
	_tb.text_array = [
		"Some venomsss will allow you to change the stats of SNAKES...",
		"This will permanently change the stats of all FUTURE venomsss that snake producesss."
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_ap.play("shop_drink")
	
	_tb.text_array = [
		"Other effects will allow you to change the statsss of VENOMS...",
		"This will change the stats of a venom until it isss consumed."
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_tb.global_position = $Markers/TopRight.global_position
	
	_ap.play("shop_antidote")
	
	_tb.text_array = [
		"I will also allow you to purchase a sssingle antidote in every shop."
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_tb.global_position = $Markers/Center.global_position
	
	_ap.play("shop_exit")
	
	_tb.text_array = [
		"When you are done, flip the sssign."
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_close()
	_tb.close()

func start_of_turn_two() -> void:
	print("start_of_turn_two")
	
	_tb.global_position = $Markers/Center.global_position
	
	_tb.text_array = [
		"A wissse player plansss ahead...",
	]
	_tb.open()
	
	await _tb.clicked_close
	
	_ap.play("arrow_shop")
	_open()
	
	_tb.text_array = [
		"Move to the right to sssee the ssshop...",
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_ap.play("arrow_collection")
	
	_tb.text_array = [
		"Move to the left sssee your collection of sssnakesss...",
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_ap.play("boss_hover")
	
	_tb.text_array = [
		"If you hover your lives, I will warn you of an upcoming ssspecial goal...",
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_close()
	
	_tb.text_array = [
		"You may also use A / D to ssswitch between ssscreens and SPACE to end the round",
	]
	_tb.update()
	
	await _tb.clicked_close
	_tb.close()

func multi_attack() -> void:
	print("multi_attack")
	
	_tb.global_position = $Markers/Center.global_position
	
	_ap.play("multi_attack")
	_open()
	
	_tb.text_array = [
		"Thisss is a multi-goal...",
		"If you passs the highessst goal, you will regain a life just like normal...",
		"However... if you fail... you will lose a life for each goal you did not passs.",
	]
	_tb.open()
	
	await _tb.clicked_close
	_close()
	_tb.close()

func _close() -> void:
	_fade_p.play("fade_out")
	await _fade_p.animation_finished

func _open() -> void:
	_fade_p.play("fade_in")
	await _fade_p.animation_finished
