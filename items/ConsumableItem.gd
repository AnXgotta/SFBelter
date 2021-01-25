extends UsableItem
class_name ConsumableItem

export(int) var health = 0
export(int) var energy = 0
export(int) var air = 0

func _ready() -> void:
	on_use_item()
	return

func on_use_item() -> void:
	print("ConsumableItem: on_use_item")
	return
