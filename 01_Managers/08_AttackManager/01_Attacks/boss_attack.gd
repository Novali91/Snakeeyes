class_name BossAttack
extends Node

var damage: Array[int]
var ability_index: int = 0

func _init(damage_to_use: Array[int], ability_index_to_use: int) -> void:
	damage = damage_to_use
	ability_index = ability_index_to_use
