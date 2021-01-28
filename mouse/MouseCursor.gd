extends Node2D



onready var player = get_parent()

var blockInput: bool = false

var hoveredInteractable = null

export(Texture) var arrow = null

onready var cursor = $CanvasLayer/Cursor
onready var itemTexture = $CanvasLayer/Cursor/Item
onready var itemLabel = $CanvasLayer/Cursor/Item/Label


func _ready() -> void:
	cursor.texture = arrow
	hide_item()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	EventManager.connect("inventory_toggled", self, "_on_inventory_toggled")
	EventManager.connect("player_opened_container", self, "_on_player_opened_container")
	EventManager.connect("mouse_slot_changed", self, "_on_mouse_item_changed")
	return

func _on_inventory_toggled(inventoryOpened: bool) -> void:
	blockInput = inventoryOpened
	return

func _on_player_opened_container(container) -> void:
	blockInput = true
	return

func _process(delta) -> void:
	_handle_collider_movement()
	cursor.set_global_position(get_global_mouse_position())
	return

func _input(event) -> void:
	_handle_mouse_click(event)
	return
	
func _handle_collider_movement() -> void:
	if blockInput:
		return
	set_global_position(get_global_mouse_position())
	return
	
func _handle_mouse_click(event) -> void:
	if blockInput:
		return
	if event.is_action_released("right_click"):
		if hoveredInteractable != null:
			player.right_clicked_object(hoveredInteractable)
	if event.is_action_released("left_click"):
		if hoveredInteractable != null:
			player.left_clicked_object(hoveredInteractable)
	return

func _on_mouse_item_changed(item: Item) -> void:
	if !(item is Item):
		hide_item()
	else:
		show_item(item.icon, item.amount)
	return

func set_cursor(mouseCursor) -> void:
	match (mouseCursor):
		Constants.MouseCursorType.ARROW:
			pass
		Constants.MouseCursorType.FINGER:
			pass
			
	return

func show_item(texture: Texture, amount: int) -> void:
	itemTexture.texture = texture
	if amount > 1:
		itemLabel.text = str(amount)
	else:
		itemLabel.text = ""
	itemTexture.visible = true

func hide_item() -> void:
	itemTexture.visible = false
	return

func _on_Area2D_area_entered(area):
	hoveredInteractable = area.get_parent()
	return


func _on_Area2D_area_exited(area):
	if hoveredInteractable == null:
		return
	if area.get_parent().get_instance_id() == hoveredInteractable.get_instance_id():
		hoveredInteractable = null
	return
