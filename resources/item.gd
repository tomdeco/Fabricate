extends Resource
## Base class for all items usable by the players and NPCs. 

class_name Item

@export var name: String
@export var icon: Texture2D
@export var mesh: PackedScene
@export var size: int

func _init(_name, _icon, _mesh, _size):
	name = _name
	icon = _icon
	mesh = _mesh
	size = _size
