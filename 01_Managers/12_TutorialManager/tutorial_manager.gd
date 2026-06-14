class_name TutorialManager
extends Node2D

signal done()

var _text_scene = preload("res://04_Helper/text_box.tscn")

var _speech: TextBox

var text: Array[String] = [
	"Greetings...",
	"Drink your poisons... match my strength...",
	"But do not push your luck..."
]

func start_tutorial() -> void:
	_speech = _text_scene.instantiate()
	_speech.text_array = text
	add_child(_speech)
	await _speech.clicked_close
	_speech.close()
	await _speech.finished_closing
	done.emit()
