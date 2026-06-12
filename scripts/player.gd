extends Entity

class_name Player

@onready var animator = get_node("model/AnimationTree")

## Camera object
@onready var cam: Camera3D = $MainCam

## Movement code specific to the player
var movement: Movement;


## The players attack instance
#var combat: Combat;

## Root of the inventory UI hirearchy
@onready var inventory_ui = $HUD/Inventory/ItemFrame
## The bone where items attach when equipped
@onready var equip_bone = $model/Armature/Skeleton3D

var wall_run_vars = {
	"collide": false,
	"time": 0
}

func _init():

	super(100, 10)
	inventory = Inventory.new(10)
	#combat = Combat.new(self, 1.5)
	movement = Movement.new(self)
	parameters[Enums.EntityParameterID.MOVEMENT_SPEED] = 10
	movement.origin_rotation = rotation
	add_child(movement)

func _ready() -> void:

	
	var rev: Weapon = Root.item_list.getWeapon("revolver")
	equip(rev)
	
	var wep: Weapon = Root.item_list.getWeapon("sword")
	addToInventory(wep)

	Hivemind.player = self
	

	
func _process(delta):	
	
	$HUD.update_hud()
	if Input.is_action_pressed("inventory"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		$HUD/Inventory.visible = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		$HUD/Inventory.visible = false
		
		applyEntityEffects(delta)
	
		
	

func _physics_process(delta: float) -> void:
	
	#combat._process(delta)
	movement.process(delta)

	use()
	animate()

## Run animation relevant routines
func animate():
	var vel = Vector2(velocity.x, velocity.z)

	#if vel.length() > 0:
		#animator.set("parameters/RunIdle/transition_request", "Run")	
	#else:
		#animator.set("parameters/RunIdle/transition_request", "Idle")
		#
	#if equipped_item is Weapon:
	#
		#if Input.is_action_pressed("attack") && equipped_item is MeleeWeapon:
			#animator.set("parameters/Type/transition_request", "melee")	
			#animator.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)	
			#
		#if Input.is_action_pressed("attack") && equipped_item is RangedWeapon:
			#animator.set("parameters/Type/transition_request", "melee")	
			#animator.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)				

func addToInventory(item: Item):
	super(item)
	inventory_ui.add_to_container(item)
	
func removeFromInventory(item: Item):
	super(item)
	
	
## Use the currently equipped item. 
func use():
	if Input.is_action_pressed("inventory"):
		return
	if Input.is_action_pressed("attack"):
		#var y = cam.rotation.y
		#rotation.y = y
		super()
		return
	if equipped_item is RangedWeapon:
		equipped_item.fire_latch = false
			

func equip(item: Item):
	#if item is Weapon:
		#combat.setWeapon(item)
	
	super(item)
	equipped_item_scene = item.mesh.instantiate()
	var current = $MainCam/EquippedItem.get_child(0)
	$MainCam/EquippedItem.remove_child(current)
	$MainCam/EquippedItem.add_child(equipped_item_scene)
	
	
		
	if item is RangedWeapon:
		item.loadRay($CameraPivot/MainCam/AimRay)
		
	
	
var rot_x = 0
var rot_y = 0
var MOUSE_OVERRIDE = false
