extends Node
## Implmentations for all abilities. Abilities hold a Callable, containing any method from this class
## Each method is prefixed with a character. M for movement, O for offensive, and D for defensive

func m_double_jump(entity: Entity):
	if Input.is_action_pressed("jump") and !entity.HAS_DOUBLE_JUMPED:
		if entity.velocity.y <= 0:
			entity.HAS_DOUBLE_JUMPED = true
			entity.velocity.y = 20
			
	if entity.is_on_floor():
		entity.HAS_DOUBLE_JUMPED = false

func m_debug_print(entity: Entity):
	print("Ability called!")
