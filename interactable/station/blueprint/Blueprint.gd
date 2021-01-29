extends Resource
class_name Blueprint

export(String) var name = ""
export(Resource) var itemProduced = null
export(int) var itemAmountProduced = 0
export(int) var productionTimeSeconds = 0
export(Array, Resource) var itemsRequired = []
export(Array, int) var itemAmountsRequired = []


func is_ingredient(item: Item) -> bool:
	if !(item is Item):
		return false
	for ing in itemsRequired:
		if ing.is_same(item.name):
			return true
	return false
