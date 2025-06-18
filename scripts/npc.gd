extends Entity
## The NPC defines a non-playable character that can be interacted with as an enemy or ally.
## To be implemented is the Enemy class, which will extend this class.

class_name NPC

## Flag indicating if NPC is invincible or not
var INVINCIBLE: bool = false

## Current entity health 
var HP: float

var ai_mode: Enums.NpcNavigationMode
var nav_agent: NavigationAgent3D

# Check if the player is within the NPCs field of view
var detection_ray: ShapeCast3D

# Check of player is obstructed (behind an obstacle)
var track_ray: RayCast3D

# If the NPC is an enemy, their current target is stored
var target: Entity

# NPC's may be given a patrol node for use in Patrol mode
var patrol: PatrolRoute
var current_routenode: RouteNode
var bone_idx: int

var semi_fire_timer: Timer
var melee_atk_timer: Timer

func _init(resource: NPCResource):
	parameters[Enums.EntityParameterID.MAX_HEALTH] = resource.max_health
	parameters[Enums.EntityParameterID.HEALTH] = resource.max_health
	parameters[Enums.EntityParameterID.BASE_DAMAGE] = resource.base_damage
	parameters[Enums.EntityParameterID.MOVEMENT_SPEED] = resource.movement_speed
	parameters[Enums.EntityParameterID.CLONITES] = resource.clonites
	ai_mode = resource.ai_mode
	
	detection_ray = ShapeCast3D.new()
	detection_ray.shape = preload("res://resources/npcs/vision_shape.tres")
	detection_ray.target_position = Vector3(0, 0, 0)
	detection_ray.position = Vector3(0, 1, 0)
	add_child(detection_ray)
	
	track_ray = RayCast3D.new()
	track_ray.position = Vector3(0, 1, 0)
	track_ray.top_level = true
	add_child(track_ray)
	
	nav_agent = NavigationAgent3D.new()
	nav_agent.navigation_layers = resource.navigation_layer

	
	add_child(nav_agent)
	
	if resource.hand_bone_name == "":
		bone_idx = -1
		
	semi_fire_timer = Timer.new()
	semi_fire_timer.wait_time = 0.65
	semi_fire_timer.one_shot = true
	
	melee_atk_timer = Timer.new()
	melee_atk_timer.wait_time = 0.5
	melee_atk_timer.one_shot = true
	
	add_child(semi_fire_timer)
	add_child(melee_atk_timer)
	add_child(resource.npc_scene.instantiate())
	

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

func equip(item: Item):
	super(item)
	equipped_item_scene = item.mesh.instantiate()
	if item is MeleeWeapon:
		item.loadHitbox(equipped_item_scene)
		
	if item is RangedWeapon:
		item.loadRay(track_ray)
		add_child(item.ray)
		
	if bone_idx < 0:
		equipped_item_scene.rotate(Vector3(0, 1, 0), PI/2)
	add_child(equipped_item_scene)
	
## Kill the NPC. Frees them from memory
func kill():
	print(name," has been slain")
	
func _process(delta: float) -> void:
	track_ray.position = position
	track_ray.position.y += 1

func set_target(pos: Vector3):
	nav_agent.target_position = pos
	
