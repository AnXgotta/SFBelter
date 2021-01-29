extends Node

# UI
signal on_change_mouse_cursor(cursorEnum)
signal menu_toggled()
signal inventory_toggled(inventoryOpen)

# Player
signal initialize_player()
signal player_health_changed(newHealthPercentage)
signal player_shield_changed(newShieldPercentage)
signal player_picked_up_item(item)
signal player_opened_container(container)

# Hotbar
signal hotbar_slot_left_clicked(slotIndex)
signal hotbar_slot_right_clicked(slotIndex)
signal hotbar_item_selected(item)
signal hotbar_previous_item_selected()
signal hotbar_next_item_selected()

# Inventory
signal inventory_slots_changed(slotIndexes)
signal inventory_slot_left_clicked(slotIndex)
signal inventory_slot_right_clicked(slotIndex)
signal mouse_slot_changed(item)

# Container
signal container_slots_changed(slotIndexes)
signal container_slot_left_clicked(slotIndex)
signal container_slot_right_clicked(slotIndex)


# Station
