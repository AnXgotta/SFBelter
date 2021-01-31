extends GridContainer


var inventory = null

func _ready() -> void:
	EventManager.connect("container_slots_changed", self, "_on_slots_changed")
	return

func update_container(containerInventory) -> void:
	inventory = containerInventory
	_update_inventory_display()
	return

func _on_slots_changed(slotIndexes) -> void:
	for i in slotIndexes:
		_update_slot_display(i)
	return

func _update_inventory_display() -> void:
	for i in range(inventory.slots.size()):
		_update_slot_display(i)
	return

func _update_slot_display(slotIndex: int) -> void:
	var slotUi = get_child(slotIndex)
	var inventoryItem = inventory.slots[slotIndex].item
	slotUi.update_display(inventoryItem)
	return
