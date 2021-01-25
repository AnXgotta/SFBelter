extends Node2D

### Mouse
enum MouseCursor { ARROW, FINGER, ITEM }

onready var player = get_parent() 

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


func _on_mouse_item_changed(item: Item) -> void:
	if !(item is Item):
		hide_item()
	else:
		show_item(item.icon, item.amount)
	return

func set_cursor(mouseCursor) -> void:
	match (mouseCursor):
		MouseCursor.ARROW:
			pass
		MouseCursor.FINGER:
			pass
			
	return

func show_item(texture: Texture, amount: int) -> void:
	itemTexture.texture = texture
	if amount > 1:
		itemLabel.text = str(amount)
	itemTexture.visible = true

func hide_item() -> void:
	itemTexture.visible = false
	return

func _on_Area2D_area_entered(area):
	print("Area ", area)


func _on_Area2D_area_exited(area):
	pass # Replace with function body.
