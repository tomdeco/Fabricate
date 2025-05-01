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
var inventory: Array

## The entities currently equipped item
var equipped_item: Item

func _init(_HP) -> void:
	inventory = []
	
	MAX_HP = _HP 
	
func equip(_item: Item):
	equipped_item = _item
