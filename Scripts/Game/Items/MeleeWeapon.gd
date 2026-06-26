extends Weapon
class_name MeleeWeapon

@export var type: Enums.MeleeWeaponTypes
@export var hitbox: Enums.MeleeWeaponHitboxSize


var area: Area3D

func _init(p_name = '', p_damage = 1, p_icon = null, p_mesh = null, p_size = 1, p_type = 0, p_hitbox = Enums.MeleeWeaponHitboxSize.NONE):
	name = p_name
	damage = p_damage
	icon = p_icon
	mesh = p_mesh
	type = p_type
	size = p_size
	hitbox = p_hitbox
	
## Load and return the weapons corresponding hitbox
static func getHitbox(_hitbox: Enums.MeleeWeaponHitboxSize) -> CollisionShape3D:
	match _hitbox:
		Enums.MeleeWeaponHitboxSize.NONE:
			return preload("res://Scene/Hitboxes/EmptyHitbox.tscn").instantiate()
		Enums.MeleeWeaponHitboxSize.SMALL:
			return preload("res://Scene/Hitboxes/SmallHitbox.tscn").instantiate()
		Enums.MeleeWeaponHitboxSize.LARGE:
			return preload("res://Scene/Hitboxes/LargeHitbox.tscn").instantiate()
	return preload("res://Scene/Hitboxes/EmptyHitbox.tscn").instantiate()
	

func use():
	super()
	var bodies = user.hitbox.get_overlapping_bodies()
	for el in bodies:
		if el != user:
			if el is Entity:
				el.receiveDamage(damage, user)

## Perform item specific setup				
func setup():
	super()
