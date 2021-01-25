extends Node

# Player State
var mouseSlotItem: Item = null
var playerInventory = preload("res://inventory/resources/Inventory.tres")
var currentContainerInventory = null


func _ready() -> void:
	EventManager.connect("player_picked_up_item", self, "_on_player_picked_up_item")
	EventManager.connect("inventory_slot_left_clicked", self, "_on_inventory_slot_left_clicked")
	EventManager.connect("inventory_slot_right_clicked", self, "_on_inventory_slot_right_clicked")
	EventManager.connect("container_slot_left_clicked", self, "_on_container_slot_left_clicked")
	EventManager.connect("container_slot_right_clicked", self, "_on_container_slot_right_clicked")
	return

func get_player_inventory():
	return playerInventory
	
func get_mouse_item() -> Item:
	return mouseSlotItem
	
func set_mouse_item(newItem: Item) -> Item:
	var previousMouseItem = mouseSlotItem
	mouseSlotItem = newItem
	EventManager.emit_signal("mouse_slot_changed", newItem)
	return previousMouseItem

	
func _on_player_picked_up_item(item) -> void:
	var remainder = playerInventory.add_item(item.get_item_resource())
	if remainder <= 0:
		item.was_picked_up()
	return
	
	
func _on_inventory_slot_left_clicked(slotIndex: int) -> void:
	print("I S L C")
	_on_slot_left_clicked(playerInventory, slotIndex)
	return
	
func _on_inventory_slot_right_clicked(slotIndex: int) -> void:
	print("I S R C")
	_on_slot_right_clicked(playerInventory, slotIndex)
	return
	
func _on_container_slot_left_clicked(slotIndex: int) -> void:
	_on_slot_left_clicked(currentContainerInventory, slotIndex)
	return
	
func _on_container_slot_right_clicked(slotIndex: int) -> void:
	_on_slot_right_clicked(currentContainerInventory, slotIndex)
	return

# handle slot being clicked on
func _on_slot_left_clicked(inventory, slotIndex: int) -> void:
	var slotItem: Item = inventory.get_item_in_slot(slotIndex)
	var slotEmpty = !(slotItem is Item)
	var mouseSlotEmpty = !(mouseSlotItem is Item)
	
	# if both mouse and item empty, we do nothing
	if  mouseSlotEmpty && slotEmpty:
		return
	
	# if slot empty and mouse slot not, put item in slot
	if slotEmpty:
		if !mouseSlotEmpty:
			# put mouse item in slot
			inventory.set_slot_item(slotIndex, mouseSlotItem)
			set_mouse_item(null)
	else:# slot not empty
		# move item from slot to mouse
		if mouseSlotEmpty:
			var previousItem = inventory.set_slot_item(slotIndex, null)
			set_mouse_item(previousItem)
		# both not empty
		elif slotItem.is_stack_full() || !slotItem.is_same(mouseSlotItem.name):
			# swap items if slot is full or they aren't the same item
			var previousItem = inventory.set_slot_item(slotIndex, mouseSlotItem)
			set_mouse_item(previousItem)
		else: # they're the same type of item, try to stack (slotItem.is_same(mouseSlotItem.name))
			var remainder = inventory.add_item_to_stack(mouseSlotItem.amount, slotIndex)
			# if all were stacked, remove item from mouse slot
			if remainder == 0:
				set_mouse_item(null)
			else: # not all fit in slot, leave remainder on mouse
				mouseSlotItem.amount = remainder
				set_mouse_item(mouseSlotItem)
	
	return

func _on_slot_right_clicked(inventory, slotIndex: int) -> void:
	print("Slot Right Clicked")
	return
