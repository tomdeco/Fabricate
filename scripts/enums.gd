extends Object

## Access parameters belonging to the Entity class
enum EntityParameterID {
	MAX_HEALTH, 	## The max HP
	HEALTH, 		## The current HP
	BASE_DAMAGE, 	## Base damage applied to entity attacks
	MOVEMENT_SPEED, 	## The base movement speed
	CLONITES ## How many clonites are carried
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

enum SpawnMarkerModes {
	ON_INIT, ## Upon game execution. For debugging only.
	PROXIMITY, ## Spawn when a player is detected within a range.
	SIGNAL ## Spawn when a signal is recieved.
}
