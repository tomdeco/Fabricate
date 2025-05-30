extends Resource
## The building blocks for EntityEffects. An Effect represents a singular buff/debuff, or other effect that may be inflicted on the entity.
class_name Effect

## Elements that may be associated to effects
enum Element {
	NA, ## No elemental aspect
	FIRE ## Fire aspected
}

var CallableOperation = {
	Enums.EffectOperations.ADD: add,
	Enums.EffectOperations.SUBTRACT: subtract,
	Enums.EffectOperations.MULTIPLY: multiply,
	Enums.EffectOperations.DIVIDE: divide
}

	
## Base name of the effect
@export var name: String

## Select the entity parameter to target
@export var target: Enums.EntityParameterID

## Specify an element to be associated with an effect. This will affect the effectiveness of the effect based on the entities elemental resistances (or lack thereof).
@export var element: Element

## The type of operation invoked by the effect. (For example, restoring health may be addition or multiplication. Losing health may be subtraction or division)
@export var operation: Enums.EffectOperations

static func perform_operation(op: Callable, x, y):
	return op.call(x, y)

static func add(x, y):
	return x + y
	
static func subtract(x, y):
	return x - y
	
static func multiply(x, y):
	return x * y
	
static func divide(x, y):
	return x / y
