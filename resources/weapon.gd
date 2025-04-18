extends Resource

class_name Weapon

@export var name: String
@export var damage: float
@export var mesh: PackedScene
@export var type: String

func _init(p_name = '', p_damage = 1, p_mesh = null, p_type = ''):
	name = p_name
	damage = p_damage
	mesh = p_mesh
	type = p_type
