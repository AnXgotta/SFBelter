extends Node2D



onready var player = get_parent() 

var hoveredInteractable = null

export(Texture) var arrow = null

onready var cursor = $CanvasLayer/Cursor
onready var itemTexture = $CanvasLayer/Cursor/Item
onready var itemLabel = $CanvasLayer/Cursor/Item/Label


func _ready() -> void:
	cursor.texture = arrow
	hide_item()
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	EventManager.connect("mouse_slot_changed", self, "_on_mouse_item_changed")
	return

func _process(delta) -> void:	
	set_global_position(get_global_mouse_position())
	cursor.set_global_position(get_global_mouse_position())
	return

func _input(event) -> void:
	_handle_mouse_click(event)
	return
	
func _handle_mouse_click(event) -> void:
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
	hoveredInteractable = null
	return
