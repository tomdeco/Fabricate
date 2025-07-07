extends Resource

## An effect that can be applied to an entity. May include one or many singular Effects.  

class_name EntityEffect

## A unique identifier belonging to the effect
@export var id: String

## The actual name of the effect (what the player sees)
@export var name: String

## The icon that will show up in the players parameters when active
@export var icon: Texture2D

## Describe the effect. Displays as a hover message.
@export var description: String

## How long the EntityEffect lasts for. A value of 0.0 indicates a one-time effect (for example, simply remove HP over no span of time). 
## This changes the effects behavior depending on the target. 
## For instance, DMG resistance is not added over a duration, but lasts over a duration. However, damage over a duration is additive.
@export var duration: float

## Time elapsed since the EntityEffect has been added to an entities effect queue.
var time_elapsed: float

## If the duration is 0.0, then the effect will apply only once
var one_shot: bool = false

## Contain the included effects.
@export var effects = Array([], TYPE_OBJECT, "Effect", Effect)

## Contain the included abilities.
@export var abilities = Array([], TYPE_OBJECT, "Ability", Ability)

func _init(_id = "na", _name = "", _icon = null, _duration = 0, _effects = [], _abilities = []) -> void:
	id = _id
	name = _name
	icon = _icon
	effects = _effects
	abilities = _abilities
	duration = _duration
	time_elapsed = 0.0
	
	if duration == 0.0:
		one_shot = true
	
func is_done() -> bool:
	return time_elapsed >= duration 
