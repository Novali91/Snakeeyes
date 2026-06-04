extends Node2D
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
var all_hovered: Array[DeckItem]

var can_hover: bool = true
signal child_was_clicked(child: DeckItem)
## Note: When ported to each diff screen, diff logic?

## Idea: Whoever adds items to this john's children needs to call add_item
func add_item(new_item: DeckItem) -> void:
	add_child(new_item)
	
	new_item.hovered.connect(child_hovered)
	new_item.unhovered.connect(child_unhovered)
	new_item.clicked.connect(child_clicked)
	pass

func remove_item(item: DeckItem, kill: bool) -> void:
	for i: int in range(all_hovered.size()):
		i -= 1
		if all_hovered[i] == item:
			all_hovered.remove_at(i)
	remove_child(item)
	if cur_hovered == item:
		find_new_hover()
	if kill:
		item.queue_free()
	pass

## How are ties broken? Can I see who is higher up in child tree?
func child_hovered(child: DeckItem) -> void:
	all_hovered.push_back(child)
	if !can_hover:
		pass
	## Check if it's higher in scene tree than cur_hovered (or if nothing hovered)
	if cur_hovered == null: # Need a bit more
		cur_hovered = child
		## Activate_hover
		child.activate_tooltip()
	pass

## TO be added
func find_new_hover() -> void:
	pass

## Need to create functionality for if hovering 2 and unhover currently selected, hover new one
func child_unhovered(child: DeckItem) -> void:
	if cur_hovered == child:
		child.deactivate_tooltip()
		## Find new cur_hovered using hovered array and what is highest in it
		cur_hovered = null
	for i: int in range(all_hovered.size()):
		i -= 1
		if all_hovered[i] == child:
			all_hovered.remove_at(i)
			continue
	pass

func child_clicked(child: DeckItem) -> void:
	if cur_hovered == child:
		child_was_clicked.emit(child)
	pass
