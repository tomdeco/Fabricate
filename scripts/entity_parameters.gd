extends Node
## Contain parameters for the player as well as NPCS including enemies. Health, status effects, and other parameters are contained here

class_name EntityParams

## How fast the entity moves without any modifiers. This is equal to 10 by default.
var MOVEMENT_SPEED = 10

## Maximum attainable HP the entity may have. 100 by default.
var MAX_HP = 100

## The current HP of the entity
var hp = 100

## Container of items the entity currently posesses
var inventory: Inventory

## The entities currently equipped item
var equipped_item: Item = null

## Create a new entity. Specify max HP and inventory size.
func _init(_HP, _inventory_size) -> void:
	inventory = Inventory.new(_inventory_size)
	MAX_HP = _HP 
	
## Equip an item to the entity
func equip(_item: Item):
	equipped_item = _item
	
func get_item(_idx: int):
	return inventory.get_item(_idx)
	
## Add an item to the entity's inventory. 
func addToInventory(_item: Item):
	inventory.add(_item)
	
