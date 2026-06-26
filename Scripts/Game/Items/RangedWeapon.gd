extends Weapon
class_name RangedWeapon

@export var type: Enums.RangedWeaponTypes
@export var fire_mode: Enums.FireMode

## Fire rate of the weapon measured in RPS (rounds per second). This is only applicable to fully automatic weapons
@export var fire_rate: float

## In semi-auto fire mode, this remains true on use and until the use method is no longer called. 
var fire_latch: bool = false

func _init(p_name = '', p_damage = 1, p_icon = null, p_mesh = null, p_size = 1, p_type = 0, p_rate = 1.0):
	name = p_name
	damage = p_damage
	icon = p_icon
	mesh = p_mesh
	type = p_type
	size = p_size
	fire_rate = p_rate
	
func use():
	super()
	
	fire_latch = true
	var el = user.rangedRayCast.get_collider()
	if el is Entity:
		print("hit")
		el.receiveDamage(damage, user)
		
