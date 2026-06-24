extends CharacterBody3D
## Base class for all animate objects. 

class_name Entity

## The name of the entity. Displayed during gameplay
@export var _name: String = "Default"

## The name used by the engine. Not shown during gameplay
@export var id: String = "default"

## Maximum acheviable health
@export var max_health: float
 
## Applicable to melee only
@export var base_damage: float 

## How fast the NPC moves in m/s
@export var movement_speed: float 

## How many clonites are dropped upon death
@export var clonites: int 

## Entity parameters including health, base damage, speed
@export var parameters = {
	Enums.EntityParameterID.MAX_HEALTH: 100, 
	Enums.EntityParameterID.HEALTH: 100, 		
	Enums.EntityParameterID.BASE_DAMAGE: 0,  		
	Enums.EntityParameterID.MOVEMENT_SPEED: 10,
	Enums.EntityParameterID.CLONITES: 0
}

var HAS_DOUBLE_JUMPED: bool = false

## Container of items the entity currently posesses
var inventory: Inventory

var equipped_item_scene: Node3D

## The entities currently equipped item
var equipped_item: Item = null

## Store all effects active on the entity
var effects = []#Array([], TYPE_OBJECT, "EntityEffect", EntityEffect)

var physics_call_queue: Array[Callable] = []

## The current angle of the floor
var currentFloorAngle: float = 0.0
## The current norm of the floor
var currentFloorNorm: Vector3 = Vector3.UP

## Node3D where item scene is instantiated
@onready var equipSlot: Node3D

## Hitbox currently used by entity
@onready var hitbox: Area3D = find_child("Hitbox")

## Raycast for ranged weapon hit detection. 
var rangedRayCast: RayCast3D

var scene: Node3D

func _init() -> void:
	name = _name

func _physics_process(delta: float) -> void:
	if physics_call_queue.size() == 0:
		return
	for callable in physics_call_queue:
		callable.call(self)
		
	physics_call_queue.clear()
	
## Equip an item to the entity
func equip(item: Item):
	equipped_item = item
	equipped_item.user = self
	equipped_item.scene = item.mesh.instantiate()
	
	var current = equipSlot.get_child(0)
	equipSlot.remove_child(current)
	equipped_item.setup() 
	equipSlot.add_child(equipped_item.scene)
	
	setHitbox(item)
	
func setHitbox(item: Item):
	var hitboxShape: CollisionShape3D
	if item is MeleeWeapon:
		hitboxShape = item.getHitbox(item.hitbox)
	else:
		hitboxShape = MeleeWeapon.getHitbox(Enums.MeleeWeaponHitboxSize.NONE)
	
	var old_hitbox = hitbox.get_child(0)
	hitbox.remove_child(old_hitbox)
	hitbox.add_child(hitboxShape)
	old_hitbox.queue_free()
		
	
func use():
	equipped_item.use()
	
func get_item(_idx: int):
	return inventory.get_item(_idx)
	
func get_hp():
	return get_parameter(Enums.EntityParameterID.HEALTH)
	
## Add an item to the entity's inventory. 
func addToInventory(_item: Item):
	inventory.add(_item)
	
func removeFromInventory(_item: Item):
	inventory.remove(_item)
	
## Give the enitity clonites
func addClonites(amount: int):
	parameters[Enums.EntityParameterID.CLONITES] += amount	

func addEntityEffect(_consumable: Consumable):
	effects.push_back(_consumable.entity_effect)
	
func applyEntityEffects(delta):
	for e_effect: EntityEffect in effects:
		if e_effect.one_shot:
			for effect: Effect in e_effect.effects:
				parameters[effect.target] = effect.perform_operation(effect.CallableOperation[effect.operation], parameters[effect.target], 10)
			
			for ability: Ability in e_effect.abilities:
				var method = Callable.create(AbilityFunctions, ability.method)
				# If the ability is of the movement type, execute it during _physics_process instead
				if ability.type == Enums.AbilityType.MOVEMENT:
					physics_call_queue.push_back(method)
				else:
					method.call(self)

			effects.erase(e_effect)	
		else:
			if e_effect.is_done():
				effects.erase(e_effect)
			else:	
				for effect: Effect in e_effect.effects:
					parameters[effect.target] = effect.perform_operation(effect.CallableOperation[effect.operation], parameters[effect.target], 10)
			
				for ability: Ability in e_effect.abilities:
					var method = Callable.create(AbilityFunctions, ability.method)
					# If the ability is of the movement type, execute it during _physics_process instead
					if ability.type == Enums.AbilityType.MOVEMENT:
						physics_call_queue.push_back(method)
					else:
						method.call(self)
	
func set_parameter(id: int, value):
	parameters[id] = value
	
func get_parameter(id: int):
	return parameters[id]
	
func receiveDamage(dmg: float):
	parameters[Enums.EntityParameterID.HEALTH] -= dmg
