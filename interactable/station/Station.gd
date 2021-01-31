extends StaticBody2D

onready var sprite: Sprite = $Sprite
onready var timer: Timer = $Timer

export(String) var stationName = ""
export(int) var powerRequired = 0

export(Array, Resource) var blueprints = []


var currentBlueprint: Resource = null
var buildTimeRemaining: int = 0

var completedItem: Resource = null


func _ready() -> void:
	timer.connect("timeout", self, "_on_timer_timeout")
	return

func on_interact() -> void:
	if completedItem != null:
		_spawn_item()
		completedItem = null
		sprite.modulate = Color(1, 1, 1)
	else:
		var index = _get_blueprint_index_for_item(PlayerManager.equippedItem)
		if index >= 0:
			#consume item
			_start_build(index)
	return


func _start_build(blueprintIndex: int) -> void:
	sprite.modulate = Color(1, 0.5, 0)
	currentBlueprint = blueprints[blueprintIndex]
	buildTimeRemaining = currentBlueprint.productionTimeSeconds
	timer.start(1)
	return
	
func _on_timer_timeout() -> void:
	buildTimeRemaining = max(0, buildTimeRemaining - 1)
	if buildTimeRemaining <= 0:
		timer.stop()
		_build_complete()
	return
	
func _build_complete() -> void:
	sprite.modulate = Color(0, 1, 0)
	completedItem = currentBlueprint.itemProduced
	currentBlueprint = null
	return


func _get_blueprint_index_for_item(playerEquippedItem: Item) -> int:
	for index in range(blueprints.size()):
		if blueprints[index].is_ingredient(playerEquippedItem):
			print("Is a valid ingredient for: ", blueprints[index].name)
			return index

	return -1

func _spawn_item() -> void:
	var itemScene = load("res://items/Item.tscn")
	var root = get_parent()
	var itemInstance = itemScene.instance()
	itemInstance.itemResource = completedItem.duplicate()
	root.add_child(itemInstance)
	itemInstance.position = position + Vector2(0, 25)
	return
