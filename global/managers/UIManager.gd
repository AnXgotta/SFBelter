extends Node


onready var tween = $Tween
onready var FADE_TIME = 0.25

### UI References
onready var hotbarRoot = $HotbarRoot
onready var hotbar = $HotbarRoot/Hotbar
onready var playerInfoRoot = $PlayerInfoRoot
onready var playerInfo = $PlayerInfoRoot/PlayerInfo
onready var inventoryRoot = $InventoryRoot
onready var inventory = $InventoryRoot/Inventory
onready var containerRoot = $ContainerRoot
onready var container = $ContainerRoot/Control

### State
var selectedItemIndex: int = -1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_controls()
	return
	
func _init_controls() -> void:
	_fade_in([playerInfoRoot, hotbarRoot])
	_fade_out([inventoryRoot, containerRoot])
	
func _fade_in(elements: Array) -> void:
	for element in elements:
		element.visible = true
#		tween.interpolate_property(element, "modulate:a", 0, 1, FADE_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 0)
#	tween.start()
	return
	
func _fade_out(elements: Array) -> void:
	for element in elements:
		element.visible = false
#		tween.interpolate_property(element, "modulate:a", 1, 0, FADE_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, 0)
#	tween.start()
	return

func hotbar_slot_left_clicked(slotIndex: int) -> void:
	hotbar._on_slot_left_clicked(slotIndex)
	return
	
func hotbar_slot_right_clicked(slotIndex: int) -> void:
	hotbar._on_slot_right_clicked(slotIndex)
	return

func hotbar_next_item_selected() -> void:
	hotbar.on_next_item_selected()
	return

func hotbar_previous_item_selected() -> void:
	hotbar.on_previous_item_selected()
	return

func inventory_toggled(inventoryOpened: bool, containerOpen: bool) -> void:
	if inventoryOpened:
		_fade_in([inventoryRoot])
		_fade_out([playerInfoRoot, hotbarRoot])
	else:
		_fade_in([playerInfoRoot, hotbarRoot])
		_fade_out([inventoryRoot])
		if containerOpen:
			_fade_out([containerRoot])
	return

func player_opened_container(containerInventory) -> void:
	container.update_container(containerInventory)
	_fade_in([inventoryRoot, containerRoot])
	_fade_out([playerInfoRoot, hotbarRoot])
	return


