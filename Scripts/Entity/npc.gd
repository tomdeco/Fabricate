extends Entity
## The NPC defines a non-playable character that can be interacted with as an enemy or ally.
## To be implemented is the Enemy class, which will extend this class.

class_name NPC

## Flag indicating if NPC is invincible or not
var INVINCIBLE: bool = false

## Current entity health 
var HP: float

@export var ai_mode: Enums.NpcNavigationMode


# If the NPC is an enemy, their current target is stored
var target: Entity

# NPC's may be given a patrol node for use in Patrol mode
var spawn: SpawnMarker
var current_routenode: RouteNode
var bone_idx: int

@onready var semi_fire_timer: Timer = $Timers/SemiFire
@onready var melee_atk_timer: Timer = $Timers/MeleeAttack
# Check if the player is within the NPCs field of view
@onready var detection_ray: ShapeCast3D = $DetectionRay
# Check of player is obstructed (behind an obstacle)
@onready var track_ray: RayCast3D = $TrackRay
@onready var patrol_route: PatrolRoute = $PatrolRoute
@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D


func equip(item: Item):
	super(item)

func use():
	if equipped_item is RangedWeapon:
		if equipped_item.fire_mode == Enums.FireMode.SEMI_AUTO and semi_fire_timer.is_stopped():
			
			print("fire")
			if track_ray.get_collider() is Player:
				var target: Player = track_ray.get_collider()
				process_accuracy(target)
				
			
			super()
			semi_fire_timer.start()
			
		return
	if equipped_item is MeleeWeapon:
		if melee_atk_timer.is_stopped():
			super()
			melee_atk_timer.start()
		return
		
	#equipped_item.use()
	
func process_accuracy(target: Entity):
	var vel = target.velocity
	var accuracy_factor = (pow(vel.length(), 2.0) / 16)
	
	if accuracy_factor > 100:
		accuracy_factor = 100
	
	if accuracy_factor <= 0:
		accuracy_factor = 1
	
	var rng = RandomNumberGenerator.new()
	var x_num = rng.randf_range(-4*accuracy_factor/100, 4*accuracy_factor/100)
	var y_num = rng.randf_range(-4*accuracy_factor/100, 4*accuracy_factor/100)
	
	if equipped_item is RangedWeapon:
		track_ray.target_position = track_ray.target_position
		track_ray.target_position.x += x_num * sin(target.rotation.x)
		track_ray.target_position.y += y_num
		track_ray.target_position.z += x_num * cos(target.rotation.x)
	
## Kill the NPC. Frees them from memory
func kill():
	print(name," has been slain")
	
func _process(delta: float) -> void:
	track_ray.position = position
	track_ray.position.y += 1
	
func _ready() -> void:
	equipSlot = find_child("Equipped")
	var spawn_marker: SpawnMarker = get_parent()
	patrol_route = spawn_marker.patrol_route
	
	current_routenode = patrol_route.get_child(0)
	position = spawn_marker.position
	
	Hivemind.add_npc(self)
	
func set_target(pos: Vector3):
	nav_agent.target_position = pos
	
