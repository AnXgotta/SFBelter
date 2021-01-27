extends GridContainer


var inventory = null

func _ready() -> void:	
	EventManager.connect("inventory_toggled", self, "_on_inventory_toggled")
	EventManager.connect("container_slots_changed", self, "_on_slots_changed")
	EventManager.connect("player_opened_container", self, "_on_player_opened_container")
	return

func _on_inventory_toggled(open) -> void:
	if !open:
		inventory = null
	return

func _on_player_opened_container(containerInventory) -> void:
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
