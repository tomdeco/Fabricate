#░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓████████▓▒░▒▓██████████████▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓███████▓▒░  
#░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
#░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒▒▓█▓▒░░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
#░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒▒▓█▓▒░░▒▓██████▓▒░ ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
#░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░ ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
#░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░ ░▒▓█▓▓█▓▒░ ░▒▓█▓▒░      ░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░ 
#░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░  ░▒▓██▓▒░  ░▒▓████████▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░  
																																																 
## The brain behind all AI processes relating to NPCs. There shall only be a single Hivemind instance at all times.
extends Node

var player: Player
var detection_verbosity = 15

## Active NPCs currently loaded. AI operations are performed on these NPCs
var active_npcs = []

## Active spawn markers currently loaded. These specify which NPCs are to be spawned
var active_spawn_markers = []

## If the player is spotted, and their location is known, this is true.
var player_location_known: bool = false

## How long the player has been out of sight by all active NPCs
var player_lost_time: float = 0.0

# Hivemind AI is enabled
var enabled: bool = true

var TIME_TILL_PLAYER_LOST = 5.0

func _physics_process(delta: float) -> void:
	if enabled:
		simulate_npcs(delta)

func add_npc(npc: NPC):
	active_npcs.push_back(npc)
	
func simulate_npcs(delta):
	player_lost_time += delta
	for npc: NPC in active_npcs:
		if npc.parameters[Enums.EntityParameterID.HEALTH] <= 0:
			kill(npc)
			continue
		match(npc.ai_mode):
			Enums.NpcNavigationMode.IDLE:
				idle(npc, delta)	
			Enums.NpcNavigationMode.PATROL:
				patrol(npc, delta)
			Enums.NpcNavigationMode.COMBAT:
				combat(npc, delta)
		
func detectPlayer(npc: NPC):
	#if npc.detection_ray.rotation.y >= PI/3:
		#npc.detection_ray.rotate(Vector3(0, 1, 0), -2*PI/3)
	
	#npc.detection_ray.rotate(Vector3(0, 1, 0), 2*PI/(3*detection_verbosity))
	var count = npc.detection_ray.get_collision_count()
	for idx in range(count):
		if npc.detection_ray.get_collider(idx) is Player:
			var player: Player = npc.detection_ray.get_collider(idx)
			var pos = (player.global_position - npc.global_position)
			npc.track_ray.target_position = pos
			if npc.track_ray.get_collider() is Player:
				npc.target = npc.track_ray.get_collider()
				npc.track_ray.target_position = Vector3(0, 0, -75)
				return true
	return false
		
func idle(npc: NPC, delta):
	player_lost_time = 0.0
	npc.velocity.x = 0
	npc.velocity.z = 0
	
	if detectPlayer(npc):
		change_ai_mode(npc, Enums.NpcNavigationMode.COMBAT)
		
	if not npc.is_on_floor():
		npc.velocity.y += -9.8 * 10 * delta
	else:
		npc.velocity.y = 0
	
	npc.move_and_slide()
	
func patrol(npc: NPC, delta):	
	npc.velocity.x = 0
	npc.velocity.z = 0
		
	npc.nav_agent.target_desired_distance = 0
	npc.nav_agent.target_position = npc.current_routenode.global_position
	
	
	if !npc.nav_agent.is_navigation_finished():
		var direction = (npc.position - npc.nav_agent.get_next_path_position()).normalized()
		npc.track_ray.target_position = direction
		npc.rotation.y = atan2(direction.x, direction.z)
		npc.velocity.x = -sin(npc.rotation.y) * 5
		npc.velocity.z = -cos(npc.rotation.y) * 5	
	else:
		npc.current_routenode = npc.current_routenode.next
		
	apply_velocity(npc, delta)
	
	if detectPlayer(npc):
		player_lost_time = 0.0
		change_ai_mode(npc, Enums.NpcNavigationMode.COMBAT)
	

	
func combat(npc: NPC, delta):
	npc.velocity.x = 0
	npc.velocity.z = 0
	
	if player_lost_time >= TIME_TILL_PLAYER_LOST:
		change_ai_mode(npc, Enums.NpcNavigationMode.PATROL)
	
	if npc.track_ray.get_collider() is Player:
		player_lost_time = 0.0
		npc.use()
	
	if npc.equipped_item is MeleeWeapon:
		close_range_routine(npc, delta)
		
	if npc.equipped_item is RangedWeapon:
		long_range_routine(npc, delta)

	
	var pos = (player.global_position - npc.global_position)
	npc.track_ray.target_position = pos

	apply_velocity(npc, delta)
	
	
## Simulate the routine for close-range attackers
func close_range_routine(npc, delta):
	npc.nav_agent.target_desired_distance = 2
	npc.nav_agent.target_position = npc.target.position
	var direction = (npc.position - npc.target.position).normalized()
	
	if !npc.nav_agent.is_navigation_finished():
		direction = (npc.position - npc.nav_agent.get_next_path_position()).normalized()
		npc.track_ray.target_position = direction
		npc.rotation.y = atan2(direction.x, direction.z)
		npc.velocity.x = -sin(npc.rotation.y) * npc.parameters[Enums.EntityParameterID.MOVEMENT_SPEED]
		npc.velocity.z = -cos(npc.rotation.y) * npc.parameters[Enums.EntityParameterID.MOVEMENT_SPEED]	
	
## Simulate the routine for long-range attackers
func long_range_routine(npc, delta):
	npc.nav_agent.target_desired_distance = 7
	npc.nav_agent.target_position = npc.target.position
	var direction = (npc.position - npc.target.position).normalized()
	
	if !npc.nav_agent.is_navigation_finished():
		direction = (npc.position - npc.nav_agent.get_next_path_position()).normalized()
		npc.track_ray.target_position = direction
		npc.rotation.y = atan2(direction.x, direction.z)
		npc.velocity.x = -sin(npc.rotation.y) * npc.parameters[Enums.EntityParameterID.MOVEMENT_SPEED]
		npc.velocity.z = -cos(npc.rotation.y) * npc.parameters[Enums.EntityParameterID.MOVEMENT_SPEED]	

func change_ai_mode(npc, mode: Enums.NpcNavigationMode):
	npc.ai_mode = mode

func apply_velocity(npc: NPC, delta):
	if not npc.is_on_floor():
		npc.velocity.y += -9.8 * 10 * delta
	else:
		npc.velocity.y = 0
	
	npc.nav_agent.velocity = npc.velocity
	npc.move_and_slide()
	
func kill(npc: NPC):
	active_npcs.erase(npc)
	npc.queue_free()
	
