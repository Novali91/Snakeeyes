extends Node
class_name TooltipManager

## To use:
# Whoever adds item to this john needs to call add_item(item)
# There is one of these for each screen, and each one controls all-
# -snakes and drinks on each screen

## Todo: Snakes/drinks need start_hover end_hover and click - Same hierarchical class
## Tooltip manager intercepts hover signals but passes up click
## Tooltip manager holds both, there are 3 (one for each area) 

## Does this call physics_tick in all of its children?

var cur_hovered: DeckItem = null

## Note: When ported to each diff screen, diff logic?

## Idea: Whoever adds items to this john's children needs to call add_item
func add_item(new_item: DeckItem) -> void:
	add_child(new_item)
	
	new_item.hovered.connect(child_hovered)
	new_item.unhovered.connect(child_unhovered)
	new_item.clicked.connect(child_clicked)
	pass

func remove_item(item: DeckItem) -> void:
	# Probably going to kill the child?
	pass

## How are ties broken? Can I see who is higher up in child tree?
func child_hovered(child: DeckItem) -> void:
	pass

## Need to create functionality for if hovering 2 and unhover currently selected, hover new one
func child_unhovered(child: DeckItem) -> void:
	pass

func child_clicked(child: DeckItem) -> void:
	print("Ho")
	print(child)
	pass
