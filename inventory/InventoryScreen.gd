extends GridContainer

var inventory = null

func _ready() -> void:
	inventory = PlayerManager.get_player_inventory()
	inventory.initialize_empty()
	EventManager.connect("inventory_slots_changed", self, "_on_slots_changed")
	initalize_display()
	return

func initalize_display() -> void:
	_update_inventory_locked_display()
	_update_inventory_display()
	return

func _update_inventory_display() -> void:
	for i in range(inventory.slots.size()):
		_update_slot_display(i)
	return
	
func _update_inventory_locked_display() -> void:
	for i in range(inventory.slots.size()):
		_update_slot_locked(i)
	return

func _on_slots_changed(slotIndexes) -> void:
	for i in slotIndexes:
		_update_slot_display(i)
	return

func _update_slot_display(slotIndex: int) -> void:
	var slotUi = get_child(slotIndex)
	var inventoryItem = inventory.slots[slotIndex].item
	slotUi.update_display(inventoryItem)
	return
	
func _update_slot_locked(slotIndex: int) -> void:
	var slotUi = get_child(slotIndex)
	var slotLocked = inventory.slots[slotIndex].locked
	slotUi.set_locked(slotLocked)
	return
