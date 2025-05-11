extends Item

class_name Weapon

## Damage dealt per hit 
@export var damage: float

## Should be specified as MELEE or RANGED
@export var type: String

func _init(p_name = '', p_damage = 1, p_icon = null, p_mesh = null, p_size = 1, p_type = ''):
	name = p_name
	damage = p_damage
	icon = p_icon
	mesh = p_mesh
	type = p_type
	size = p_size
