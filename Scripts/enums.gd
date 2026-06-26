extends Node

## Access parameters belonging to the Entity class
enum EntityParameterID {
	MAX_HEALTH, 	## The max HP
	HEALTH, 		## The current HP
	BASE_DAMAGE, 	## Base damage applied to entity attacks
	MOVEMENT_SPEED, 	## The base movement speed
	CLONITES ## How many clonites are carried
}

## Flags specifically for handling KB+M control schemes
enum DiscreteMovementFlag {
	FORWARD,
	BACKWARD,
	LEFT,
	RIGHT,
	JUMP,
	DASH
}

## The three modes an NPC can be in
enum NpcNavigationMode {
	IDLE,
	PATROL,
	COMBAT
}

## Operations that carry out the effects
enum EffectOperations {
	ADD,
	SUBTRACT,
	MULTIPLY,
	DIVIDE
}

enum MeleeWeaponTypes {
	BLUNT,
	BLADE
}

enum MeleeWeaponHitboxSize {
	NONE, ## No hitbox
	SMALL, ## Narrow hitbox, can only hit a single target
	LARGE ## Wider hitbox, can hit multiple targets
}

enum RangedWeaponTypes {
	GUN,
	THROWABLE,
	EMITTER 
}

enum InstantUseItemType {
	CLONITE, ## Give the user a specified amount of Clonites
	RECIPIE ## Unlock a recipe for the user
}

enum FireMode {
	SEMI_AUTO, ## Semi-Automatic, single fire with auto loading
	AUTO ## Fully automatic, spray and pray baby
}

enum SpawnMarkerModes {
	ON_INIT, ## Upon game execution. For debugging only.
	PROXIMITY, ## Spawn when a player is detected within a range.
	SIGNAL ## Spawn when a signal is recieved.
}

## Classifications for the three types of abilities
enum AbilityType {
	MOVEMENT,
	OFFENSIVE,
	DEFENSIVE
}
