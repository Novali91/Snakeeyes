class_name TutorialManager
extends CanvasLayer

func close() -> void:
	print("closed")
	await get_tree().create_timer(0.1).timeout



func start_of_turn_one() -> void:
	print("start_of_turn_one")
	await get_tree().create_timer(0.1).timeout


func drinks_drunk() -> void:
	print("drinks_drunk")
	await get_tree().create_timer(0.1).timeout


func end_turn_pressed() -> void:
	print("end_turn_pressed")
	await get_tree().create_timer(0.1).timeout


func dice_rerolled() -> void:
	print("dice_rolled")
	await get_tree().create_timer(0.1).timeout


func entered_shop() -> void:
	print("entered_shop")
	await get_tree().create_timer(0.1).timeout


func antidote_bought() -> void:
	print("antidote_bought")
	await get_tree().create_timer(0.1).timeout


func start_of_turn_two() -> void:
	print("start_of_turn_two")
	await get_tree().create_timer(0.1).timeout


func special_attack() -> void:
	print("special_attack")
	await get_tree().create_timer(0.1).timeout


func multi_attack() -> void:
	print("multi_attack")
	await get_tree().create_timer(0.1).timeout
