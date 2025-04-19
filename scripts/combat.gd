extends Node

## A class for adding attack abilities to any entities in-game. 
## Includes parameters for properties such as attack speed, TBA. Intended for use by players and enemies.
class_name Combat

## Parent PhysicsBody3D the combat object belongs to
var PARENT: PhysicsBody3D

## The speed at which the entity attacks (applies to melee only)
var ATTACK_SPEED

## How far the entities melee attack will reach
var ATTACK_REACH

## How long the entity must wait before melee attacking again
var MELEE_TIMER = 0

## A boolean stating if the entity is currently attacking. Allows attacking to be a one-shot action.
var IS_ATTACKING = false

## The weapon currently in use
var EQUIPPED_WEAPON

var EQUIPPED_WEAPON_MESH : BoneAttachment3D

## Initialize combat values specific to the entity
func _init(parent, _ATTACK_SPEED: float):
	PARENT = parent
	ATTACK_SPEED = _ATTACK_SPEED	
	
	
	

func _process(delta: float) -> void:
	if MELEE_TIMER > 0:
		MELEE_TIMER -= delta
		print(MELEE_TIMER)
	
func set_attack_speed(SPEED: float):
	ATTACK_SPEED = SPEED

func setWeapon(weapon: Weapon):
	EQUIPPED_WEAPON = weapon
	EQUIPPED_WEAPON_MESH = EQUIPPED_WEAPON.mesh.instantiate()

func melee_attack(hitbox: Area3D):
	if MELEE_TIMER <= 0:
		var bodies = hitbox.get_overlapping_bodies()
		for el in bodies:
			if isNPC(el):
				var npc = el as NPC
				npc.receiveDamage(EQUIPPED_WEAPON.damage)
				
		MELEE_TIMER = ATTACK_SPEED

func isNPC(entity: PhysicsBody3D):
	if entity != PARENT:
		if entity is NPC:
			return true
	return false	
