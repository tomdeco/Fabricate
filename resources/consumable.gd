extends Item
class_name Consumable

## An Item type that is single-use by the player. Used to gain health, buffs, and other effects

@export var entity_effect: EntityEffect

func _init(_name = "", _id = "", _icon = null, _mesh = null, _size = 1, _entity_effect = null):
	name = _name
	id = _id
	icon = _icon
	mesh = _mesh
	size = _size
	entity_effect = _entity_effect
