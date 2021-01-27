extends Control

enum SlotType { INVENTORY, HOTBAR, CONTAINER }

export(SlotType) var type = SlotType.INVENTORY

export(Texture) var backgroundNotSelected = null
export(Texture) var backgroundSelected = null
export(Texture) var backgroundLocked = null

signal slot_selected(slotIndex)

onready var slotBackground = $Background
onready var itemImage = $Background/Item
onready var amountLabel = $Background/Item/Label


func _ready() -> void:
	slotBackground.texture = backgroundNotSelected
	return

func _gui_input(event) -> void:
	if event.is_action_released("left_click"):
		EventManager.emit_signal(_get_signal_string("left_clicked"), get_index())
	if event.is_action_released("right_click"):
		EventManager.emit_signal(_get_signal_string("right_clicked"), get_index())
	return

func _get_signal_string(buttonClickString: String) -> String:
	var pre: String = ""
	match(type):
		SlotType.INVENTORY:
			pre = "inventory"
		SlotType.HOTBAR:
			pre = "hotbar"
		SlotType.CONTAINER:
			pre = "container"
			
	print(pre + "_slot_" + buttonClickString)
	return (pre + "_slot_" + buttonClickString)

func update_display(item: Item) -> void:
	if item is Item:
		itemImage.texture = item.icon
		if item.amount > 1:
			amountLabel.text = str(item.amount)
		else:
			amountLabel.text = ""
	else:
		itemImage.texture = null
		amountLabel.text = ""
	return

func set_selected(selected: bool) -> void:
	if selected:
		slotBackground.texture = backgroundSelected
	else:
		slotBackground.texture = backgroundNotSelected
	return
	
func set_locked(locked: bool) -> void:
	if locked:
		slotBackground.texture = backgroundLocked
	return
