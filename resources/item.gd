extends Resource
## Base class for all items usable by the players and NPCs. 

class_name Item

@export var name: String
@export var mesh: PackedScene

func _init(_name, _mesh):
	name = _name
	mesh = _mesh
