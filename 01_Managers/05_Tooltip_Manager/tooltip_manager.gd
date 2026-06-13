extends Node2D
class_name TooltipManager

## To use:
# Whoever adds item to this john needs to call add_item(item), and if you remove a child-
# -call remove_item(item)

# There is one of these for each screen, and each one controls all-
# -snakes and drinks on each screen

# Whenever a child (drink/snake) is hovered or unhovered or clicked-
# -the tooltip manager managing that child receives those signals.
# For hover: look at child_hovered(child)
# For unhover: look at child_unhovered(child)
# For click: look at child_clicked(child)

# Whenever things should not be hoverable, call turn_off_hover()
# But make sure to call turn_on_hover() when things should then be hoverable

@export var x_sort: bool = false

var cur_hovered: DeckItem = null
var all_hovered: Array[DeckItem]

## Set false when camera moves, maybe other cases too (use turn_off_hover()/turn_on_hover())
var can_hover: bool = true

signal child_was_clicked(child: DeckItem)

## Called whenever this manages any new DeckItems and sets them up
func add_item(new_item: DeckItem) -> void:
	add_child(new_item)
	
	new_item.hovered.connect(child_hovered)
	new_item.unhovered.connect(child_unhovered)
	new_item.clicked.connect(child_clicked)
	pass

## Should be called whenever this stops managing any DeckItems
## Removes their logic with this tooltip_manager
func remove_item(item: DeckItem, kill: bool) -> void:
	# If this child is currently hovered, remove its tooltip
		# If it is in all_hovered, remove it from it
	for i: int in range(all_hovered.size()):
		i -= 1
		if all_hovered[i] == item:
			all_hovered.remove_at(i)
	
	if cur_hovered == item:
		item.deactivate_tooltip()
		if all_hovered.size() > 0:
			activate_child(find_new_hover())
		else:
			cur_hovered = null
	
	
	item.hovered.disconnect(child_hovered)
	item.unhovered.disconnect(child_unhovered)
	item.clicked.disconnect(child_clicked)
	remove_child(item)
	
	if kill:
		item.queue_free()
	pass

## This function activates whenever any child is hovered.
## It handles adding it to all_hovered and figuring out if it is the front-most node-
## -and therefore should have its tooltip appear
func child_hovered(child: DeckItem) -> void:
	all_hovered.push_back(child)
	if !can_hover:
		return
	
	# If nothing is hovered currently:
	if (cur_hovered == null):
		activate_child(child)
	# If something is currently hovered, but this child is above it:
	elif (child.get_index() > cur_hovered.get_index()):
		cur_hovered.deactivate_tooltip()
		activate_child(child)
	pass

## This function finds which hovered child is at the front/highest
func find_new_hover() -> DeckItem:
	var cur_front_index: float = -1
	var cur_front_node: DeckItem = null
	var temp_index: float
	
	# Find front node
	for item: DeckItem in all_hovered:
		temp_index = item.get_index()
		
		if x_sort:
			temp_index = item.position.x
		
		elif y_sort_enabled:
			temp_index = item.position.y
		
		if (temp_index > cur_front_index) or (cur_front_index == -1):
			cur_front_index = temp_index
			cur_front_node = item
	
	return cur_front_node

## This function should be used whenever activating any child's hover
func activate_child(child: DeckItem) -> void:
	cur_hovered = child
	child.activate_tooltip()
	pass

## Whenever a child is unhovered
func child_unhovered(child: DeckItem) -> void:
	# Remove this child from the all_hovered array
	for i: int in range(all_hovered.size()):
		i -= 1
		if all_hovered[i] == child:
			all_hovered.remove_at(i)
			break
	
	# Returns if this child isn't the currenly hovered child
	if !(cur_hovered == child):
		return
	
	# This code only executes if this child's tooltip was currently displayed
	child.deactivate_tooltip()
	# If nothing else is hovered:
	if all_hovered.size() == 0:
		cur_hovered = null
	else:
		# Find new cur_hovered using hovered array and what is highest in it
		activate_child(find_new_hover())
	pass

## Ensures that only the hovered child (with a visible tooltip) can get clicked/drank/bought
func child_clicked(child: DeckItem) -> void:
	if cur_hovered == child:
		child_was_clicked.emit(child)
	pass

## Should be called whenever things shouldn't be able to be hovered
func turn_off_hover() -> void:
	can_hover = false
	cur_hovered.deactivate_tooltip()
	cur_hovered = null
	return

## Should be called whenever things should now be able to be hovered
func turn_on_hover() -> void:
	can_hover = true
	activate_child(find_new_hover())
	return
