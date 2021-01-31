extends Node2D

var hoveredInteractable = null

export(Texture) var arrow = null

onready var cursor = $CanvasLayer/Cursor
onready var itemTexture = $CanvasLayer/Cursor/Item
onready var itemLabel = $CanvasLayer/Cursor/Item/Label


func _ready() -> void:
	cursor.texture = arrow
	hide_item()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
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
	if event.is_action_released("right_click"):
		if hoveredInteractable != null:
			pass
	if event.is_action_released("left_click"):
		if hoveredInteractable != null:
			pass
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
	hoveredInteractable = area.get_parent()
	return


func _on_Area2D_area_exited(area):
	if hoveredInteractable == null:
		return
	if area.get_parent().get_instance_id() == hoveredInteractable.get_instance_id():
		hoveredInteractable = null
	return
