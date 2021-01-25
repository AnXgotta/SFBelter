extends Node


### UI References
onready var menuRoot = $MenuRoot
onready var hotbarRoot = $HotbarRoot
onready var containerContainer = $MenuRoot/MenuContainer/ContainerContainer


### State
enum TabType { INVENTORY, PLAYER, SETTINGS}
var currentTab: int = 0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	menuRoot.visible = false
	hotbarRoot.visible = true
	containerContainer.visible = false
	EventManager.connect("menu_toggled", self, "on_menu_toggled")
	EventManager.connect("inventory_toggled", self, "on_inventory_toggled")

	return

func on_inventory_toggled() -> void:
	
	if !menuRoot.visible:
		menuRoot.visible = true
		hotbarRoot.visible = false
		_switch_tabs(TabType.INVENTORY)
	else:
		menuRoot.visible = false
		hotbarRoot.visible = true
	return

func _switch_tabs(nextTab) -> void:
			
	return
