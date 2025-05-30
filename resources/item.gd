extends Resource
## Base class for all items usable by the players and NPCs. 

class_name Item

@export var name: String
@export var icon: Texture2D
@export var mesh: PackedScene
@export var size: int

## A short, identifying name for the item. This is not the same as the actual name of the weapon. Should be the same as the actual resource name as well.
@export var id: String

func _init(_name, _id, _icon, _mesh, _size):
	name = _name
	id = _id
	icon = _icon
	mesh = _mesh
	size = _size
	
func use():
	pass
