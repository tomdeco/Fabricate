extends RigidBody3D
## In-game objects that are interactable
class_name InteractBody

## Interact with an object. Takes the player interacting with it is an arugment
func interact(player: Player):
	pass
	
## Dismiss the object interaction. Used for closing UI elements.
func dismiss(player: Player):
	pass
