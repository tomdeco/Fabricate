extends Item

class_name EntityContainer


## Use type EntityData, not implemented yet
@export var entity: PackedScene

func _init(_name, _id, _icon, _mesh, _size, _entity):
	name = _name
	id = _id
	icon = _icon
	mesh = _mesh
	size = _size
	entity = _entity
