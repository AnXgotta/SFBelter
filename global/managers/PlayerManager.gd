extends Node2D


#Refs
var player = null
onready var mouseCursor = $MouseCursor
onready var UIManager = $UIManager

# Player State
var mouseSlotItem: Item = null
var playerInventory = preload("res://inventory/resources/Inventory.tres")
var currentContainerInventory = null

var equippedItem = null
var equippedItemIndex = -1

# Interaction
export(float) var interactRange = 32

var inventoryOpen: bool = false
var containerOpen: bool = false


func _ready() -> void:
	player = get_tree().get_nodes_in_group("player")[0]
	playerInventory.initialize_empty()
	## Inventory / Hotbar / Container
	EventManager.connect("inventory_toggled", self, "_on_inventory_toggled")
	EventManager.connect("inventory_slot_left_clicked", self, "_on_inventory_slot_left_clicked")
	EventManager.connect("inventory_slot_right_clicked", self, "_on_inventory_slot_right_clicked")
	EventManager.connect("container_slot_left_clicked", self, "_on_container_slot_left_clicked")
	EventManager.connect("container_slot_right_clicked", self, "_on_container_slot_right_clicked")
	EventManager.connect("hotbar_previous_item_selected", self, "_on_hotbar_previous_item_selected")
	EventManager.connect("hotbar_next_item_selected", self, "_on_hotbar_next_item_selected")
	EventManager.connect("hotbar_slot_left_clicked", self, "_on_hotbar_slot_left_clicked")
	EventManager.connect("hotbar_slot_right_clicked", self, "_on_hotbar_slot_right_clicked")
	EventManager.connect("hotbar_item_equipped", self, "_on_hotbar_item_equipped")
	
	## Interaction
	EventManager.connect("player_picked_up_item", self, "_on_player_picked_up_item")
	EventManager.connect("player_consumed_item", self, "_on_player_consumed_item")
	EventManager.connect("player_opened_container", self, "_on_player_opened_container")
	
	return
	
func get_player_inventory() -> Inventory:
	return playerInventory

func _is_in_range(otherLocation: Vector2) -> bool:
	return (player.get_global_position() - otherLocation).length() <= interactRange

func _on_inventory_toggled() -> void:
	inventoryOpen = !inventoryOpen
	UIManager.inventory_toggled(inventoryOpen, containerOpen)
	return

func _on_inventory_slot_left_clicked(slotIndex: int) -> void:
	_on_slot_left_clicked(playerInventory, slotIndex)
	return
	
func _on_inventory_slot_right_clicked(slotIndex: int) -> void:
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
	print("Slot ", slotIndex, " Right Clicked: ", inventory.name)
	return

func _on_hotbar_previous_item_selected() -> void:
	if inventoryOpen:
		return
	UIManager.hotbar_previous_item_selected()
	return

func _on_hotbar_next_item_selected() -> void:
	if inventoryOpen:
		return
	UIManager.hotbar_next_item_selected()
	return

func _on_hotbar_slot_left_clicked(slotIndex: int) -> void:
	UIManager.hotbar_slot_left_clicked(slotIndex)
	return

func _on_hotbar_slot_right_clicked(slotIndex: int) -> void:
	UIManager.hotbar_slot_right_clicked(slotIndex)
	return

func _on_player_opened_container(containerInventory) -> void:
	currentContainerInventory = containerInventory
	inventoryOpen = true
	containerOpen = true
	UIManager.player_opened_container(currentContainerInventory)
	return

func _on_player_picked_up_item(itemObject) -> void:
	var remainder = playerInventory.add_item(itemObject.get_item_resource())
	itemObject.was_picked_up(remainder)
	return

func _on_player_consumed_item(item, slotIndex) -> void:
	print("Player Consumed Item: ", item.name, " at slot ", slotIndex)
	return

func _on_hotbar_item_equipped(item) -> void:
	equippedItem = item
	return

func get_mouse_item() -> Item:
	return mouseSlotItem
	
func set_mouse_item(newItem: Item) -> Item:
	var previousMouseItem = mouseSlotItem
	mouseSlotItem = newItem
	return previousMouseItem

func should_block_movement() -> bool:
	return inventoryOpen
	
func should_block_mouse_input() -> bool:
	return inventoryOpen
