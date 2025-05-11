extends Node

class_name Inventory

## The size of the inventory. Corresponds to "blocks" available for storage
var SIZE

## Items are stored here 
var _contents: Array

## Create a new inventory. Specify the inventory size.
func _init(size: int):
	SIZE = size	

## Add an item to the inventory.
func add(item: Item):
	_contents.push_back(item)		

func get_item(idx: int) -> Item:
	return _contents[idx]
	
func get_storage_space():
	return _contents.size()
