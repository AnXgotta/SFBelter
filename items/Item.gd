extends Resource
class_name Item

export(Constants.ItemType) var type = Constants.ItemType.UNK
export(String) var name = ""
export(String) var description = ""
export(String) var toolTip = ""
export(Texture) var icon = null
export(int) var maxStack = 1
var amount:int = 1 


func is_same(otherName: String) -> bool:
	return name == otherName
	
func is_stack_full() -> bool:
	return amount == maxStack

func get_icon() -> Texture:
	return icon

func get_amount() -> int:
	return amount

func get_name() -> String:
	return name

func consume_one() -> int:
	amount -= 1
	return amount
