extends Node2D

var hoveredInteractable = []

export(Texture) var arrow = null

onready var cursor = $CanvasLayer/Cursor
onready var itemTexture = $CanvasLayer/Cursor/Item
onready var itemLabel = $CanvasLayer/Cursor/Item/Label

func _ready() -> void:
	cursor.texture = arrow
	hide_item()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	EventManager.connect("mouse_slot_updated", self, "_on_mouse_slot_updated")
	return

func _process(delta) -> void:
	_handle_collider_movement()
	cursor.set_global_position(get_global_mouse_position())
	return

func _input(event) -> void:
	_handle_mouse_click(event)
	return
	
func _handle_collider_movement() -> void:
	if PlayerManager.should_block_mouse_input():
		return
	set_global_position(get_global_mouse_position())
	return
	
func _handle_mouse_click(event) -> void:
	if PlayerManager.should_block_mouse_input():
		return
	if event.is_action_released("left_click"):
		print("Left Click")
		if hoveredInteractable.size() > 0:
			EventManager.emit_signal("player_left_clicked_object", hoveredInteractable[0])
	if event.is_action_released("right_click"):
		if hoveredInteractable.size() > 0:
			EventManager.emit_signal("player_right_clicked_object", hoveredInteractable[0])
	return

func _on_mouse_slot_updated(item: Item) -> void:
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
	print("Show Item: ", amount)
	itemTexture.texture = texture
	if amount > 1:
		itemLabel.text = str(amount)
		itemLabel.visible = true
	else:
		itemLabel.text = ""
	itemTexture.visible = true

func hide_item() -> void:
	itemTexture.visible = false
	itemLabel.visible = false
	return

func _on_Area2D_area_entered(area):
	print("Hovered: ", area.get_parent().name)
	hoveredInteractable.push_front(area.get_parent())
	return


func _on_Area2D_area_exited(area):
	print("Exited: ", area.get_parent().name)
	if hoveredInteractable.size() == 0:
		return
	hoveredInteractable.pop_front()
	return
