extends Node2D


export(Resource) var itemResource = null


func _ready() -> void:
	if !(itemResource is Item):
		print("You forgot to set the Item Resource")
		return
	$Sprite.texture = itemResource.icon
	return

func get_item_resource() -> Item:
	return itemResource


func was_picked_up() -> void:
	queue_free()
	return
