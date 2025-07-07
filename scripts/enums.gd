extends Object

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
	JUMP
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

enum RangedWeaponTypes {
	GUN,
	THROWABLE,
	EMITTER 
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
