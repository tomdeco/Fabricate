extends Weapon
class_name MeleeWeapon

@export var type: Enums.MeleeWeaponTypes


var area: Area3D
var parent: Entity


func _init(p_name = '', p_damage = 1, p_icon = null, p_mesh = null, p_size = 1, p_type = 0):
	name = p_name
	damage = p_damage
	icon = p_icon
	mesh = p_mesh
	type = p_type
	size = p_size

func use():
	#var hitbox: Area3D = scene.get_child(1)
	var bodies = area.get_overlapping_bodies()
	for el in bodies:
		if el != parent:
			if el is Entity:
				el.receiveDamage(damage)
				
func loadHitbox(loaded_scene: BoneAttachment3D):
	area = loaded_scene.get_node("Hitbox")
