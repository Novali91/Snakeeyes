class_name BossTooltip
extends Node2D

## I imagine attack_manager will call this on the drink being hovered?
## Note: it uses the index to math out turn number, so keep that in mind when moving abilities around
func activate_boss_attack_tooltip(upcoming_index: int) -> void:
	match upcoming_index:
		1:
			pass
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			pass
		6:
			pass
		
	pass

func get_description(upcoming: int) -> String:
	match upcoming:
		1:
			"You mussst match my ssstrength exxxxactly...."
		2:
			pass
		3:
			pass
		4:
			pass
		5:
			pass
		6:
			pass
		7:
			pass
		8:
			pass
		9:
			pass
		10:
			pass
	return ""
