extends HBoxContainer

var HOTBAR_SIZE: int = 8

var inventory = null
var currentSelectedSlot = -1

func _ready() -> void:
	inventory = InventoryManager.get_player_inventory()
	EventManager.connect("inventory_slots_changed", self, "_on_slots_changed")	
	EventManager.connect("hotbar_slot_left_clicked", self, "_on_slot_left_clicked")
	EventManager.connect("hotbar_slot_right_clicked", self, "_on_slot_right_clicked")
	return
	
func _on_slot_left_clicked(slotIndex: int) -> void:
	var slotItem = _set_slot_selected(true, slotIndex)
	EventManager.emit_signal("hotbar_item_selected", slotItem)
	return
	
func _on_slot_right_clicked(slotIndex: int) -> void:	
	print("HB RC: ", slotIndex)
	return
	
func _update_inventory_display() -> void:
	for i in range(HOTBAR_SIZE):
		_update_slot_display(i)
	return
	
func _on_slots_changed(slotIndexes) -> void:
	for i in slotIndexes:
		if i < HOTBAR_SIZE:
			_update_slot_display(i)
	return

func _update_slot_display(slotIndex: int) -> void:
	var slotUi = get_child(slotIndex)
	var inventoryItem = inventory.slots[slotIndex].item
	slotUi.update_display(inventoryItem)
	if slotIndex == currentSelectedSlot:
		EventManager.emit_signal("hotbar_item_selected", inventoryItem)
	return

func _set_slot_selected(selected: bool, slotIndex: int) -> Item:
	if selected && currentSelectedSlot >= 0:
		_set_slot_selected(false, currentSelectedSlot)
	
	currentSelectedSlot = slotIndex
	var slotUi = get_child(slotIndex)
	var inventoryItem = inventory.slots[slotIndex].item
	slotUi.set_selected(selected)
	return inventoryItem
