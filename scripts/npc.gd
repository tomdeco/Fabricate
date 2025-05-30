extends Entity
## The NPC defines a non-playable character that can be interacted with as an enemy or ally.
## To be implemented is the Enemy class, which will extend this class.

class_name NPC

## Flag indicating if NPC is invincible or not
var INVINCIBLE: bool = false

## Current entity health 
var HP: float

var nav_agent: NavigationAgent3D

func _init(resource: NPCResource):
	parameters[Enums.EntityParameterID.MAX_HEALTH] = resource.max_health
	parameters[Enums.EntityParameterID.HEALTH] = resource.max_health
	parameters[Enums.EntityParameterID.BASE_DAMAGE] = resource.base_damage
	parameters[Enums.EntityParameterID.MOVEMENT_SPEED] = resource.movement_speed
	parameters[Enums.EntityParameterID.CLONITES] = resource.clonites

	
	add_child(resource.scene.instantiate())
	nav_agent = NavigationAgent3D.new()
	
## Deal damage to the entity
func receiveDamage(dmg: float):
	HP -= dmg
	
## Kill the NPC. Frees them from memory
func kill():
	print(name," has been slain")
	free()
	
func _process(delta: float) -> void:
	if parameters[Enums.EntityParameterID.HEALTH] <= 0:
		kill()
	
	
func _physics_process(delta: float) -> void:
	move(delta)

func move(delta: float):
	#var pos = nav_agent.get_next_path_position()
	#var direction = (pos - position).normalized()
	#velocity.x = direction.x * parameters[Enums.EntityParameterID.MOVEMENT_SPEED]	
	#velocity.z = direction.z * parameters[Enums.EntityParameterID.MOVEMENT_SPEED]	
	
	if not is_on_floor():
		velocity.y += -9.8 * 10 * delta
	else:
		velocity.y = 0
		
	move_and_slide()
	
func set_target(pos: Vector3):
	nav_agent.target_position = pos
