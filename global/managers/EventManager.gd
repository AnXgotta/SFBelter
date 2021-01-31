extends Node

# UI
signal on_change_mouse_cursor(cursorEnum)
signal inventory_toggled()

# Player
signal initialize_player()
signal player_health_changed(newHealthPercentage)
signal player_shield_changed(newShieldPercentage)
signal player_picked_up_item(itemObject)
signal player_opened_container(container)
signal player_consumed_item(item, slotIndex)

# Hotbar
signal hotbar_slot_left_clicked(slotIndex)
signal hotbar_slot_right_clicked(slotIndex)
signal hotbar_item_equipped(item)
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
