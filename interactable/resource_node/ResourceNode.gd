extends Interactable


export(String) var displayName = ""
export(int) var healthPoints = 0
export(Array, String) var validToolNames = []
export(Resource) var producedItem = null
export(int) var numberItemsProduced = 0


func can_interact(itemInHand) -> bool:
	return (itemInHand is Item) && (itemInHand.type == Constants.ItemType.TOOL) && (validToolNames.has(itemInHand.name))

func on_interact(toolUsed: Item) -> void:
	if !can_interact(toolUsed):
		return
		
	healthPoints = max(0, healthPoints - toolUsed.damage)
	if(healthPoints <= 0):
		_spawn_items()
		_destroy_self()
	return

func _destroy_self() -> void:
	queue_free()
	return

func _spawn_items() -> void:
	var itemScene = load("res://items/Item.tscn")
	var root = get_parent()
	for i in range(numberItemsProduced):
		var itemInstance = itemScene.instance()
		itemInstance.itemResource = producedItem.duplicate()
		root.add_child(itemInstance)
		itemInstance.position = position + Vector2(rand_range(-25, 25), rand_range(-25, 25))
	return

