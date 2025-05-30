extends Button

## A button that takes an Item as a parameter

class_name EquipButton

var item
var rect
var slot

func _init(_item: Item, _rect: Rect2, _slot):
	item = _item
	rect = _rect
	icon = item.icon
	slot = _slot
	
