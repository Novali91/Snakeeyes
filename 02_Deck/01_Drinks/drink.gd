extends Node
class_name Drink

# Drink stats
@export var poison: int
@export var charm: int
@export var rep: int

# For tooltip
@export var description: String = ""
@export var flavour_text: String

# Stub function: called when drinking
func special_effect() -> void:
	pass
