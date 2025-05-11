extends CharacterBody3D

class_name Player

@onready var animator = get_node("model/AnimationTree")

## Camera object
@onready var cam = $CameraPivot 

## Entity parameters belonging to the player
var params: EntityParams

## Movement code specific to the player
var movement: Movement;

## The players attack instance
var combat: Combat;

## Root of the inventory UI hirearchy
@onready var inventory_ui = $HUD/HUD/Inventory

## The bone where items attach when equipped
@onready var equip_bone = $model/Armature/Skeleton3D


## A reference to the players currently equipped weapon resource. 
#var equipped_item


## A reference to the players currently equipped weapon mesh. Weapons use the BoneAttachment3D node in order to attach to their hand
var equipped_item_mesh: BoneAttachment3D

var wall_run_vars = {
	"collide": false,
	"time": 0
}

func _init():
	params = EntityParams.new(100, 10)
	combat = Combat.new(self, 1.5)
	movement = Movement.new(self)
	params.MOVEMENT_SPEED = 10
	movement.origin_rotation = rotation
	add_child(movement)

func _ready() -> void:
	var wep: Weapon = $"..".weapon_list.getWeapon("Sword")
	addToInventory(wep)
	equip(wep)
	cam.rotation.y = rotation.y
	

	
func _process(delta):	
	
	if Input.is_action_pressed("inventory"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$HUD/HUD/Inventory.visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$HUD/HUD/Inventory.visible = false

func _physics_process(delta: float) -> void:
	
	combat._process(delta)
	movement.process(delta, self)
	
	attack(delta)
	animate()

## Run animation relevant routines
func animate():
	var vel = Vector2(velocity.x, velocity.z)

	if vel.length() > 0:
		animator.set("parameters/RunIdle/transition_request", "Run")	
	else:
		animator.set("parameters/RunIdle/transition_request", "Idle")
		
	if Input.is_action_pressed("attack") && combat.MELEE_TIMER == combat.ATTACK_SPEED:
		animator.set("parameters/Type/transition_request", "melee")	
		animator.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)	
		
	if Input.is_action_pressed("attack") && combat.EQUIPPED_WEAPON.type == "RANGED":
		animator.set("parameters/Type/transition_request", "ranged")	
		animator.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)				

func addToInventory(item: Item):
	params.addToInventory(item)
	inventory_ui.add_to_container(item)
	
func attack(delta: float):
	if Input.is_action_pressed("attack"):
		if combat.EQUIPPED_WEAPON.type == "MELEE":
			var hitbox: Area3D = combat.EQUIPPED_WEAPON_MESH.get_child(1)
			combat.melee_attack(hitbox)
		if combat.EQUIPPED_WEAPON.type == "RANGED":
			var y = $CameraPivot.rotation.y
			rotation.y = y
			combat.ranged_attack()
	
func equip(item: Item):
	if equip_bone.get_child_count() > 0:
		equip_bone.remove_child(equipped_item_mesh)
	
	if item is Weapon:
		combat.setWeapon(item)
		params.equip(item)
	equipped_item_mesh = item.mesh.instantiate()
	equip_bone.add_child(equipped_item_mesh)
	var idx = equip_bone.find_bone("forearm.R")
	equipped_item_mesh.bone_idx = idx
	
