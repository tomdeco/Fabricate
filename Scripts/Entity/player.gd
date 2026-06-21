extends Entity

class_name Player


## Camera object
@onready var cam: Camera3D = $WorldViewContainer/WorldView/MainCam

## Root of the inventory UI hirearchy
@onready var inventory_ui = $HUD/Inventory/ItemFrame



## Movement code specific to the player
var movement: Movement;

var wall_run_vars = {
	"collide": false,
	"time": 0
}

func _init():

	#super(100, 10)
	inventory = Inventory.new(10)
	#combat = Combat.new(self, 1.5)
	movement = Movement.new(self)
	parameters[Enums.EntityParameterID.MOVEMENT_SPEED] = 10
	movement.origin_rotation = rotation
	add_child(movement)
	
	

func _ready() -> void:
	equipSlot = $ItemViewContainer/ItemView/ItemCam/EquippedItem
	var rev: Weapon = Root.item_list.getWeapon("revolver")
	var sword: Weapon = Root.item_list.getWeapon("sword")
	equip(sword)
	addToInventory(rev)
	

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
	
	cam.position.x = position.x
	cam.position.y = position.y + 1.5
	cam.position.z = position.z
		
	

func _physics_process(delta: float) -> void:
	movement.process(delta)
	use()

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
		
			
var rot_x = 0
var rot_y = 0
var MOUSE_OVERRIDE = false
