extends Item

class_name Weapon

## Damage dealt per hit 
@export var damage: float

func _init(p_name = '', p_damage = 1, p_icon = null, p_mesh = null, p_size = 1):
	name = p_name
	damage = p_damage
	icon = p_icon
	mesh = p_mesh
	size = p_size
	
func use():
	pass
