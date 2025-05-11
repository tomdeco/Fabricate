extends Resource

## A resource for defining an effect invokable on entities. This includes stat increases, healing effects, and other unique effects. For use with the EntityParams class

class_name Effect

@export var id: String
@export var name: String

func _init(_name) -> void:
	name = _name
