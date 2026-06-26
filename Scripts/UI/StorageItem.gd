extends HBoxContainer
class_name StorageItem

var item: Item
var _name: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_name = $MarginContainer/Name
	
func init(_item: Item):
	item = _item
	_name.text = item.name
