extends Weapon
class_name RangedWeapon

@export var type: Enums.RangedWeaponTypes

var ray: RayCast3D

func _init(p_name = '', p_damage = 1, p_icon = null, p_mesh = null, p_size = 1, p_type = 0):
	name = p_name
	damage = p_damage
	icon = p_icon
	mesh = p_mesh
	type = p_type
	size = p_size


func use():
	var el = ray.get_collider()
	if el is NPC:
		el.receiveDamage(damage)
		
func loadRay(_ray: RayCast3D):
	ray = _ray
