extends CharacterBody3D

class_name Player

@onready var animator = get_node("model/AnimationTree")

## Camera object
@onready var cam = $CameraPivot 

### Ray Cast Object. Detect grabbable walls
#@onready var grab_ray = $"Rays/Wall Grab"
#
#@onready var mantle_ray = $Rays/Mantle
#
#@onready var l_wallrun_ray = $Rays/WallRunLeft
#
#@onready var r_wallrun_ray = $Rays/WallRunRight
#
#@onready var floor_ray = $Rays/Floor

## Entity parameters belonging to the player
var params: EntityParams

### Player constant velocity (in meters per second).
#var PLAYER_SPEED = 10
#
### The speed added by dashing
#var DASH_SPEED = 10
#
### The player velocity before external forces such as gravity or momentum
#var INITAL_VELOCITY: Vector3
#
### The current velocity of the player. All changes made to player speed are made through here, and then applied to its root node 
#var CURRENT_VELOCITY: Vector3
#
#var ACCELERATION: float = 0

### Original rotation from last time the player is non-stationary.
#var origin_rotation = rotation
#
### Whether the camera acts as free-look or crosshair.
#var STATIONARY_CONTINUOUS_TURN = false 

## Movement code specific to the player
var movement: Movement;

## The players attack instance
var combat: Combat;

## A reference to the players currently equipped weapon resource. 
var equipped_weapon

## A reference to the players currently equipped weapon mesh. Weapons use the BoneAttachment3D node in order to attach to their hand
var equipped_weapon_mesh: BoneAttachment3D

### Handle all timing and related functions for the dash ability 
#var dash_timer: Timer
#
### Time to wait after dashing
#var dash_wait_timer: Timer
#
#var wall_timer: Timer
#
#var isWallGrabbed = false
#var isWallGrabDisabled = false
#var isAutoGrabbingEnabled = false
#var isWallRunning = false
#var isOnRamp = false
#
#var currentNormal = Vector3(0, 1, 0)

var wall_run_vars = {
	"collide": false,
	"time": 0
}

func _init():
	params = EntityParams.new(100)
	combat = Combat.new(self, 1.5)
	movement = Movement.new(self)
	params.MOVEMENT_SPEED = 10
	movement.origin_rotation = rotation
	add_child(movement)

func _ready() -> void:
	cam.rotation.y = rotation.y
	setWeapon("Revolver", "RANGED")

	

func _physics_process(delta: float) -> void:
	
	combat._process(delta)
	movement.process(delta, self)
	#move(delta)
	
	#grab_ray.target_position = Vector3(0, 0, -0.5)
	#mantle_ray.target_position = Vector3(0, 0, -0.7)
	#l_wallrun_ray.target_position = Vector3(-1.0, 0, 0)
	#r_wallrun_ray.target_position = Vector3(1.0, 0, 0)
	#floor_ray.target_position = Vector3(0, -1.0, 0)
	
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

#func add_initial_velocity(direction: Vector3, speed: float):
	#INITAL_VELOCITY.x = direction.x * speed
	#INITAL_VELOCITY.y = direction.y * speed
	#INITAL_VELOCITY.z = direction.z * speed
#
#func add_velocity(direction: Vector3, speed: float):
#
	#CURRENT_VELOCITY.x += direction.x * speed
	#CURRENT_VELOCITY.y += direction.y * speed
	#CURRENT_VELOCITY.z += direction.z * speed
	#
	#
#
#func move_forward(delta, _cam_rotation):
	#if(Input.is_action_pressed("move_left")):
		#rotation.y = cam.rotation.y + PI/4
	#else:
		#if Input.is_action_pressed("move_right"):
			#rotation.y = cam.rotation.y - PI/4
		#else:
			#rotation.y = cam.rotation.y
	#var direction = Vector3(-sin(rotation.y), 0, -cos(rotation.y))
	#add_initial_velocity(direction, PLAYER_SPEED)
	#
	#
#func move_backward(delta, _cam_rotation):
	#
	#if abs(CURRENT_VELOCITY.length()) > 0:
		#CURRENT_VELOCITY.x = 0
		#CURRENT_VELOCITY.z = 0 
		#return
	#
	#if(Input.is_action_pressed("move_left")):
		#rotation.y = _cam_rotation.y - PI - PI/4
	#else:
		#if Input.is_action_pressed("move_right"):
			#rotation.y = _cam_rotation.y - PI + PI/4
		#else:
			#rotation.y = _cam_rotation.y - PI
			#
	#var direction = Vector3(-sin(rotation.y), 0, -cos(rotation.y))
	#add_initial_velocity(direction, PLAYER_SPEED)
	#
#
#func move_left(delta, _cam_rotation):
	#rotation.y = _cam_rotation.y + PI/2
	#var direction = Vector3(-sin(rotation.y), 0, -cos(rotation.y))
	#add_initial_velocity(direction, PLAYER_SPEED)
	#
#
	#
#func move_right(delta, _cam_rotation):
#
	#rotation.y = _cam_rotation.y - PI/2
	#var direction = Vector3(-sin(rotation.y), 0, -cos(rotation.y))
	#add_initial_velocity(direction, PLAYER_SPEED)
	#
	#
#func jump(delta, acceleration):
	#if Input.is_action_pressed("jump") and is_on_floor():
		#add_velocity(currentNormal, 25)	
		##CURRENT_VELOCITY += INITAL_VELOCITY
				#
#func dash(delta):
	#var direction = Vector3(-sin(rotation.y), 0, -cos(rotation.y))
	#if dash_wait_timer.is_stopped():
		#add_velocity(direction, DASH_SPEED)
		#dash_timer.start()
		#dash_wait_timer.start()
#
		#
	#
	#
#func wallrun(delta):
	##return false
	#var leftCollision = l_wallrun_ray.is_colliding()
	#var rightCollision = r_wallrun_ray.is_colliding() 
	#var isColliding = leftCollision or rightCollision
	#var isMoving = false
	#
	#if CURRENT_VELOCITY.x + CURRENT_VELOCITY.z != 0:
		#isMoving = true
		#
	#if is_on_floor() or !isMoving:
		#isWallRunning = false
		#return false	
		#
	#if Vector2(CURRENT_VELOCITY.x, CURRENT_VELOCITY.z).length() < 20:
		#return
	 #
	#if isMoving and isColliding and !is_on_floor():
		#isWallRunning = true
	#
	#if isWallRunning:
		#if 	leftCollision:
			#var normal: Vector3 = l_wallrun_ray.get_collision_normal()
			#rotation.y = atan2(normal.x, normal.z) - PI/2
		#else:
			#var normal: Vector3 = r_wallrun_ray.get_collision_normal()
			#rotation.y = atan2(normal.x, normal.z) + PI/2
	#
		#if Input.is_action_pressed("move_backward"):
			#isWallRunning = false
			#return false
			#
		#if Input.is_action_pressed("jump"):
			#isWallRunning = false
			#if leftCollision:
				#rotation.y -= PI/2
				#velocity.y = 10
				#add_initial_velocity(rotation, PLAYER_SPEED)
				#
				#
			#if rightCollision:
				#rotation.y += PI/2	
				#velocity.y = 25
				#add_initial_velocity(rotation, PLAYER_SPEED)
				#
			#return false
				#
		#velocity.y = -2 
		#return true
	#return false
			#
		#
#func wall_grapple(delta, acceleration):
	#var state = grab_ray.is_colliding()
	#if !is_on_floor() and !isWallGrabDisabled:
		#if (isWallGrabbed and Input.is_action_just_pressed("jump")):
			#isWallGrabbed = false
			#isAutoGrabbingEnabled = true
			#rotation.y -= PI
			#var direction = Vector3(-sin(rotation.y), 0, -cos(rotation.y))
			#add_velocity(direction, PLAYER_SPEED)
			#add_velocity(Vector3(0, 1, 0), 25)
			#return
		#
		#if (state and Input.is_action_just_pressed("jump") and !isWallGrabbed) or (state and isAutoGrabbingEnabled and !isWallGrabbed):
			#isWallGrabbed = true
					#
		#if (isWallGrabbed and state) or (isAutoGrabbingEnabled and state):
			#var normal: Vector3 = grab_ray.get_collision_normal()		
			#rotation.y = atan2(normal.x, normal.z)
			#CURRENT_VELOCITY = Vector3.ZERO
			#
		#if Input.is_action_pressed("move_backward"):
			#isAutoGrabbingEnabled = false
			#isWallGrabbed = false
			#isWallGrabDisabled = true
	#
	#if is_on_floor():
		#isWallGrabDisabled = false
		#isAutoGrabbingEnabled = false
	#
	#var mantle_state = !mantle_ray.is_colliding()
	#if state and mantle_state:
			#isWallGrabbed = true
			#velocity.y = 0
			#velocity.x = 0
			#velocity.z = 0	
			#if Input.is_action_pressed("move_forward"):
				#var displacement = Vector3(-sin(rotation.y), mantle_ray.position.y , -cos(rotation.y))
				#position += displacement
				#isWallGrabbed = false
				#
#func applyMomentum(delta):
	#var direction = Vector3(-sin(rotation.y), 0, -cos(rotation.y))
	#var magnitude = abs(Vector2(CURRENT_VELOCITY.x, CURRENT_VELOCITY.z).length())
	#CURRENT_VELOCITY.x = 0
	#CURRENT_VELOCITY.z = 0
	#
	#add_velocity(direction, magnitude)
	#
	#if is_on_floor():
		#CURRENT_VELOCITY.y = 0
		#
	#if is_on_wall():
		#var wall = get_wall_normal()
		#if wall.y == 0:
			#CURRENT_VELOCITY.x = 0
			#CURRENT_VELOCITY.z = 0
#
	#if floor_ray.is_colliding():
		#var normal = floor_ray.get_collision_normal()
		#var diff = cos(rotation.z) - normal.y
		#if normal.y != 1:
			#var vec = Vector3(normal.x, normal.y - 0.5, normal.z)
			#var new_vel = magnitude*delta*normal.y
			#print(vec)
			#
			#add_velocity(vec,new_vel)
	#
	#if is_on_floor():
		#var decrease = 2 * delta
		#var normal_direction = CURRENT_VELOCITY.normalized()
		#add_velocity(-direction, (magnitude * 0.25 * delta))
		#
		#if magnitude < PLAYER_SPEED:
			#CURRENT_VELOCITY.x = 0
			#CURRENT_VELOCITY.z = 0
#
#
### Handles basic player movement (even better tho)
#func move(delta):		
	#var horizontal_acceleration = -9.8 * 5
	#var fall_acceleration = -9.8 * 10
	#var target_velocity = Vector3.ZERO
	#var cam_rotation: Vector3 = $CameraPivot.rotation
	#var direction = Vector3(-sin(rotation.y), 0, -cos(rotation.y))
	#var magnitude = abs(Vector2(CURRENT_VELOCITY.x, CURRENT_VELOCITY.z).length())
	#
	#applyMomentum(delta)
	#
	#if is_on_floor():	
		#if Input.is_action_pressed("move_forward"):
			#STATIONARY_CONTINUOUS_TURN = false
			##origin_rotation = rotation
			#move_forward(delta, cam_rotation)
		#else:
			#if Input.is_action_pressed("move_backward"):
				#move_backward(delta, cam_rotation)
			#else:
				#if Input.is_action_pressed("move_left"):
					#move_left(delta, cam_rotation)
				#else:
					#if Input.is_action_pressed("move_right"):
						#move_right(delta, cam_rotation)
					#else:	
						#INITAL_VELOCITY = Vector3.ZERO
						#var rotation_diff = cam_rotation - origin_rotation		
						#if(cos(rotation_diff.y) < 0 || STATIONARY_CONTINUOUS_TURN):
							#STATIONARY_CONTINUOUS_TURN = true
							#rotation.y = cam_rotation.y
	#else:
		#CURRENT_VELOCITY += INITAL_VELOCITY
		#INITAL_VELOCITY = Vector3.ZERO
		#if Input.is_action_just_pressed("move_forward"):
			#if abs(rotation.y - cam.rotation.y) > PI/2:
				#CURRENT_VELOCITY.x = CURRENT_VELOCITY.x / 2
				#CURRENT_VELOCITY.z = CURRENT_VELOCITY.z / 2
				##add_velocity(direction, 5)
			#else: 
				#if CURRENT_VELOCITY.x + CURRENT_VELOCITY.z == 0:
					#add_velocity(direction, 5)
		#else:
			#if Input.is_action_just_pressed("move_backward"):
				#if abs(rotation.y - cam.rotation.y) < PI/2 and CURRENT_VELOCITY.x + CURRENT_VELOCITY.z > 0:
					#CURRENT_VELOCITY.x = CURRENT_VELOCITY.x / 2
					#CURRENT_VELOCITY.z = CURRENT_VELOCITY.z / 2
					##add_velocity(direction, 5)
			#else:
				#if Input.is_action_just_pressed("move_left"):
					#if rotation.y < cam.rotation.y:
						#CURRENT_VELOCITY.x = CURRENT_VELOCITY.x / 2
						#CURRENT_VELOCITY.z = CURRENT_VELOCITY.z / 2
						##add_velocity(direction, -5)
				#else:
					#if Input.is_action_just_pressed("move_right"):
						#if rotation.y > cam.rotation.y:
							#CURRENT_VELOCITY.x = CURRENT_VELOCITY.x / 2
							#CURRENT_VELOCITY.z = CURRENT_VELOCITY.z / 2
							##add_velocity(direction, -5)
			#
		#
	#if Input.is_action_pressed("dash") or !dash_timer.is_stopped():
		#dash(delta)
		#
	#jump(delta, fall_acceleration)
	#wall_grapple(delta, fall_acceleration)		
	#
#
#
	##var direction = Vector3(-sin(rotation.y), 0, -cos(rotation.y))
	##if abs(CURRENT_VELOCITY.x + CURRENT_VELOCITY.z) > 0:
		##ACCELERATION += delta
		##CURRENT_VELOCITY.x -= (0.1 * ACCELERATION * direction.x)
		##CURRENT_VELOCITY.z -= (0.1 * ACCELERATION * direction.z)
	##else:
		##ACCELERATION = 0
	#
	#
	#
	#
	#
	#if !wallrun(delta):
		#if !isWallGrabbed:
			#if !is_on_floor():
				#add_velocity(Vector3(0, 1, 0), fall_acceleration * delta)
		#
				#
	#
#
	#velocity = INITAL_VELOCITY + CURRENT_VELOCITY	
#
	##print(CURRENT_VELOCITY)
	##print(velocity)
	#move_and_slide()

func attack(delta: float):
	if Input.is_action_pressed("attack"):
		if combat.EQUIPPED_WEAPON.type == "MELEE":
			var hitbox: Area3D = equipped_weapon_mesh.get_child(1)
			combat.melee_attack(hitbox)
		if combat.EQUIPPED_WEAPON.type == "RANGED":
			var y = $CameraPivot.rotation.y
			rotation.y = y
			combat.ranged_attack()
	
		

func setWeapon(name: String, type: String):
	removeWeapon()
	
	var weplist = $"..".weapon_list as WeaponList
	var weapon: Weapon = weplist.getWeapon(name, type)
	
	equipped_weapon_mesh = weapon.mesh.instantiate()
	$model/Armature/Skeleton3D.add_child(equipped_weapon_mesh)
	var idx = $model/Armature/Skeleton3D.find_bone("forearm.R")
	equipped_weapon_mesh.bone_idx = idx
	combat.setWeapon(weapon)

func removeWeapon():
	$model/Armature/Skeleton3D.remove_child(equipped_weapon_mesh)
	combat.EQUIPPED_WEAPON = Weapon.new()
