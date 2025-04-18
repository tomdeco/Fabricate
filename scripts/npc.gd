extends RigidBody3D
## The NPC defines a non-playable character that can be interacted with as an enemy or ally.
## To be implemented is the Enemy class, which will extend this class.

class_name NPC

## Flag indicating if NPC is invincible or not
var INVINCIBLE: bool = false

## Maximum attainable health to entity
var MAX_HP: float

## Current entity health 
var HP: float

func _init(_MAX_HP: float):
	MAX_HP = _MAX_HP
	HP = MAX_HP

## Deal damage to the entity
func receiveDamage(dmg: float):
	HP -= dmg
	
## Kill the NPC. Frees them from memory
func kill():
	print(name," has been slain")
	free()
	
func _process(delta: float) -> void:
	if HP <= 0:
		kill()
