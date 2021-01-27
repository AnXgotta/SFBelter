extends Item
class_name ConsumableItem

export(int) var health = 0
export(int) var energy = 0
export(int) var air = 0

func _ready() -> void:
	return

func on_consume_item() -> void:
	print("ConsumableItem: on_consume_item")
	
	return
