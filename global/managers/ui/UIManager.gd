extends Node


onready var tween = $Tween
onready var FADE_TIME = 0.25

### UI References
onready var hotbar = $HotbarRoot
onready var playerInfo = $PlayerInfoRoot
onready var inventory = $InventoryRoot
onready var container = $ContainerRoot

### State
var inventoryOpen: bool = false
var containerOpen: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_controls()
	EventManager.connect("menu_toggled", self, "_on_menu_toggled")
	EventManager.connect("inventory_toggled", self, "_on_inventory_toggled")
	EventManager.connect("player_opened_container", self, "_on_player_opened_container")
	EventManager.connect("hotbar_previous_item_selected", self, "_on_hotbar_previous_item_selected")
	EventManager.connect("hotbar_next_item_selected", self, "_on_hotbar_next_item_selected")
	
	return
	
func _init_controls() -> void:
	_fade_in([playerInfo, hotbar])
	_fade_out([inventory, container])
	
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

func _on_hotbar_next_item_selected() -> void:
	if inventoryOpen:
		return
	hotbar.get_child(0).on_next_item_selected()
	return

func _on_hotbar_previous_item_selected() -> void:
	if inventoryOpen:
		return
	hotbar.get_child(0).on_previous_item_selected()
	return

func _on_inventory_toggled(inventoryOpened: bool) -> void:
	inventoryOpen = inventoryOpened
	if inventoryOpened:
		_fade_in([inventory])
		_fade_out([playerInfo, hotbar])
	else:
		_fade_in([playerInfo, hotbar])
		_fade_out([inventory])
		if containerOpen:
			containerOpen = false
			_fade_out([container])
	return

func _on_player_opened_container(containerInventory) -> void:
	inventoryOpen = true
	containerOpen = true
	_fade_in([inventory, container])
	_fade_out([playerInfo, hotbar])
	return

func _switch_tabs(nextTab) -> void:
			
	return
