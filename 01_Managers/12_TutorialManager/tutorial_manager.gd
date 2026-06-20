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
		"welcome",
		"this is a simple drinking game"
	]
	_tb.open()
	
	await _tb.clicked_close
	
	##
	_ap.play("strength")
	_open()
	
	_tb.text_array = [
		"this is your strength meter"
	]
	_tb.update()
	
	await _tb.clicked_close
	
	##
	_ap.play("tickers")
	
	_tb.text_array = [
		"every round I will set a strength goal",
	]
	_tb.update()
	
	await _tb.clicked_close
	
	##
	_tb.global_position = $Markers/Center.global_position
	
	_ap.play("lives")
	
	_tb.text_array = [
		"if you fail to meet the goal, you will lose a life",
		"if you manager to succeed, I will give you a life back"
	]
	_tb.update()
	
	await _tb.clicked_close
	
	##
	_tb.global_position = $Markers/TopRight.global_position
	
	_ap.play("drinks")
	
	_tb.text_array = [
		"to gain strength you will drink venoms",
	]
	_tb.update()
	
	await _tb.clicked_close
	
	##
	_ap.play("drink_strength")
	
	_tb.text_array = [
		"some drinks will give you strength to win the round"
	]
	_tb.update()
	
	await _tb.clicked_close
	
	##
	_ap.play("drink_charm")
	
	_tb.text_array = [
		"others will give you charm to get more snakes"
	]
	_tb.update()
	
	await _tb.clicked_close
	
	##
	_tb.global_position = $Markers/Center.global_position
	
	_ap.play("poison")
	
	_tb.text_array = [
		"but ingesting venoms is dangerous, the more you drink-",
		"the higher the chance you pass out"
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_close()
	
	_tb.text_array = [
		"for now, simply drink all your venoms"
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
		"to tell me you are done drinking, ring the bell",
	]
	_tb.open()
	
	await _tb.clicked_close
	await _close()
	_tb.close()


func end_turn_pressed() -> void:
	print("end_turn_pressed")
	
	_tb.global_position = $Markers/Center.global_position
	
	_tb.text_array = [
		"new we will roll the dice to see if you pass out",
	]
	_tb.open()
	
	await _tb.clicked_close
	
	await _tb.close()


func dice_rolled() -> void:
	print("dice_rolled")
	
	_tb.global_position = $Markers/TopRight.global_position
	
	_tb.text_array = [
		"sssnake eyesss...",
		"...",
		"since you rolled lower than your poison, normally you would pass out",
		"and you would lose all your strength and charm",
		"however I have let you start with an antidote",
		"antidotes let you reroll the dice"
	]
	_tb.open()
	
	await _tb.clicked_close
	_tb.close()

func compare_strength() -> void:
	print("compare_strength")
	
	_tb.global_position = $Markers/Center.global_position
	
	_tb.text_array = [
		"now lets see if you beat the goal I set"
	]
	_tb.open()
	
	await _tb.clicked_close
	_tb.close()

func entered_shop() -> void:
	print("entered_shop")
	
	_tb.global_position = $Markers/Center.global_position
	
	_tb.text_array = [
		"now you can add more snakes to your collection",
		"when you refill, each snake in your collection produces its poison",
		"different poisons have different stats and effects",
	]
	_tb.open()
	
	await _tb.clicked_close
	
	_ap.play("shop_snake")
	_open()
	
	_tb.text_array = [
		"some effects will allow you to change the stats of SNAKES",
		"this will permanently change the stats of all FUTURE venoms that snake produces"
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_ap.play("shop_drink")
	
	_tb.text_array = [
		"other effects will allow you to change the stats of DRINKS",
		"this will change the stats of a singular drink until it is consumed"
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_tb.global_position = $Markers/TopRight.global_position
	
	_ap.play("shop_antidote")
	
	_tb.text_array = [
		"I will also allow you to buy a single antidote in every shop"
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_tb.global_position = $Markers/Center.global_position
	
	_ap.play("shop_exit")
	
	_tb.text_array = [
		"when you are done, click here to exit the shop"
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_close()
	_tb.close()

func start_of_turn_two() -> void:
	print("start_of_turn_two")
	
	_tb.global_position = $Markers/Center.global_position
	
	_tb.text_array = [
		"its always a good idea to plan ahead",
	]
	_tb.open()
	
	await _tb.clicked_close
	
	_ap.play("arrow_shop")
	_open()
	
	_tb.text_array = [
		"you can check the shop by pressing this arrow",
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_ap.play("arrow_collection")
	
	_tb.text_array = [
		"you can check your collection by pressing this arrow",
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_ap.play("boss_hover")
	
	_tb.text_array = [
		"you can hover this to see an upcoming special goal",
	]
	_tb.update()
	
	await _tb.clicked_close
	
	_close()
	
	_tb.text_array = [
		"you can also use A / D to switch between screens and SPACE to end the round",
	]
	_tb.update()
	
	await _tb.clicked_close
	_tb.close()

func multi_attack() -> void:
	print("multi_attack")
	
	_ap.play("multi_attack")
	_open()
	
	_tb.text_array = [
		"this is a multi goal round",
		"if you pass the highest goal, you will regain a life like normal",
		"but if you fail, you will lose a life for each goal you did not pass",
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
