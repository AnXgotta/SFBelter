extends Resource

class_name Inventory

enum InventoryType { INVENTORY, CONTAINER }

export(InventoryType) var type = InventoryType.INVENTORY
export(int) var inventorySize = 24
export(int) var lockedSlots = 16
var slots : Array = [] # InventorySlot


func get_item_in_slot(index: int) -> Item:
	var item = null
	if slots.size() > index:
		item = slots[index].item 
	
	return item

func initailize(size: int, numberLocked: int) -> void:
	inventorySize = size
	lockedSlots = numberLocked
	initialize_empty()
	return

func initialize_empty() -> void:
	var inventorySlot = load("res://inventory/resources/InventorySlot.tres");
	var lockedSlotThreashhold = ((inventorySize - 1) - lockedSlots);
	for i in range(inventorySize):
		var newSlot = inventorySlot.duplicate()
		newSlot.locked = i > lockedSlotThreashhold
		slots.push_back(newSlot)
	return


func add_item(item: Item, slotIndex: int = -1) -> int:
	if !(item is Item):
		return -1
	
	var amountToAdd: int = item.amount
	
	# try to add item to existing stacks
	while amountToAdd > 0:
		var availableStackIndex: int = _find_available_stack(item.name)
		if availableStackIndex >= 0:
			amountToAdd = add_item_to_stack(amountToAdd, availableStackIndex)
		else:
			break
	
	# try to add item to empty slots
	while amountToAdd > 0:
		var availableSlotIndex: int = _find_available_slot()
		if availableSlotIndex >= 0:
			set_slot_item(availableSlotIndex, item)
			amountToAdd = 0
		else:
			break
	# return remaining items if inventory is full
	return amountToAdd

# get index of first availble stack of same item with space
func _find_available_stack(itemName: String) -> int:
	for i in range(slots.size()):
		var item = slots[i].item
		if item is Item && item.is_same(itemName) && !item.is_stack_full():
			return i
	return -1

# get index of first available empty slot
func _find_available_slot() -> int:
	for i in range(slots.size()):
		if !slots[i].locked && !(slots[i].item is Item):
			return i
	return -1

# add item amount to stack
func add_item_to_stack(amount: int, toSlotIndex: int) -> int:
	var toSlotItem = slots[toSlotIndex].item
	var itemMaxStack = toSlotItem.maxStack
	var itemCurrentAmount = toSlotItem.amount
	
	var newAmount = itemCurrentAmount + amount
	var remainder = 0
	if newAmount > itemMaxStack:
		remainder = newAmount - itemMaxStack
		slots[toSlotIndex].item.amount = itemMaxStack
	else:
		slots[toSlotIndex].item.amount = newAmount
	
	_emit_slots_changed([toSlotIndex])
	return remainder

func set_slot_item(slotIndex, item) -> Item:
	var previousItem = slots[slotIndex].item
	slots[slotIndex].item = item
	_emit_slots_changed([slotIndex])
	return previousItem

func remove_slot_item(slotIndex) -> Item:
	var previousItem = slots[slotIndex].item
	slots[slotIndex].item = null
	_emit_slots_changed([slotIndex])
	return previousItem

func _emit_slots_changed(indeces) -> void:
	var iType = "inventory"
	match(type):
		InventoryType.INVENTORY:
			iType = 'inventory'
		InventoryType.CONTAINER:
			iType = 'container'	
	
	EventManager.emit_signal(iType + "_slots_changed", indeces)	
	return
