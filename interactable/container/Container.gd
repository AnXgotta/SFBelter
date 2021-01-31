extends Interactable

onready var inventory = null


func _ready() -> void:
	inventory = load("res://interactable/container/Container.tres").duplicate()
	inventory.initialize_empty()
	return


func on_interact() -> void:
	EventManager.emit_signal("player_opened_container", inventory)
	return
