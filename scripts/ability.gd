extends Resource
class_name Ability

## Temporary abilities that can be applied to any entity. These modify functionalities available to an entity, including movement and attacking.
## Four types of abilities can be used. Movement, offensive, defensive, and parametric.

@export var name: String
@export var type: Enums.AbilityType
@export var method: String
