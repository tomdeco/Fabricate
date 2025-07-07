extends CharacterBody3D
## Base class for all animate objects. 

class_name Entity

## Entity parameters including health, base damage, speed
var parameters = {
	Enums.EntityParameterID.MAX_HEALTH: 100, 
	Enums.EntityParameterID.HEALTH: 100, 		
	Enums.EntityParameterID.BASE_DAMAGE: 0,  		
	Enums.EntityParameterID.MOVEMENT_SPEED: 10,
	Enums.EntityParameterID.CLONITES: 0
}

var HAS_DOUBLE_JUMPED: bool = false

## Container of items the entity currently posesses
var inventory: Inventory

## The entities currently equipped item
var equipped_item: Item = null

## A reference to the players currently equipped weapon mesh. Weapons use the BoneAttachment3D node in order to attach to their hand
var equipped_item_scene: BoneAttachment3D

## Store all effects active on the entity
var effects = []#Array([], TYPE_OBJECT, "EntityEffect", EntityEffect)

var physics_call_queue: Array[Callable] = []

func _physics_process(delta: float) -> void:
	if physics_call_queue.size() == 0:
		return
	for callable in physics_call_queue:
		callable.call(self)
		
	physics_call_queue.clear()

## Create a new entity. Specify max HP and inventory size.
func _init(_HP, _inventory_size) -> void:
	inventory = Inventory.new(_inventory_size)
	set_parameter(Enums.EntityParameterID.MAX_HEALTH, _HP)
	set_parameter(Enums.EntityParameterID.HEALTH, _HP)
	
## Equip an item to the entity
func equip(_item: Item):
	equipped_item = _item 
	if equipped_item is MeleeWeapon:
		equipped_item.parent = self
	
func use():
	equipped_item.use()
	
	if equipped_item is RangedWeapon:
		for child in equipped_item_scene.get_children():
			if child is GPUParticles3D:
				child.restart()
	
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
