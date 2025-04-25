extends CharacterBody3D

@onready var animator = get_node("model/AnimationTree")

## Camera object
@onready var cam = $CameraPivot 

## Ray Cast Object. Detect grabbable walls
@onready var grab_ray = $"Wall Grab"

@onready var mantle_ray = $Mantle

#@onready var feet = $Feet

@onready var l_wallrun_ray = $WallRunLeft

@onready var r_wallrun_ray = $WallRunRight

## Player constant velocity (in meters per second).
var PLAYER_SPEED = 10

## The speed added by dashing
var DASH_SPEED = 10

## Original rotation from last time the player is non-stationary.
var origin_rotation = rotation

## Whether the camera acts as free-look or crosshair.
var STATIONARY_CONTINUOUS_TURN = false 

## The players attack instance
var combat: Combat;

## A reference to the players currently equipped weapon resource. 
var equipped_weapon

## A reference to the players currently equipped weapon mesh. Weapons use the BoneAttachment3D node in order to attach to their hand
var equipped_weapon_mesh: BoneAttachment3D

## Handle all timing and related functions for the dash ability 
var dash_timer: Timer

var wall_timer: Timer

var wall_jump_vars = {
	"wait_latch": false,
	"mantle_latch": false,
	"collide": false,
	"wall": null
}

var wall_run_vars = {
	"collide": false,
	"time": 0
}

func _init():
	combat = Combat.new(self, 1.5)
	dash_timer = Timer.new() 
	wall_timer = Timer.new()
	

func _ready() -> void:
	setWeapon("Revolver", "RANGED")
	initalizeTimers()
	
func initalizeTimers():
	# Dash Timer
	dash_timer.one_shot = true
	dash_timer.wait_time = 0.25
	dash_timer.stop()
	add_child(dash_timer)
	
	# Wall-jump Timer
	wall_timer.one_shot = true
	wall_timer.wait_time = 1.5
	add_child(wall_timer)
	
func _physics_process(delta: float) -> void:
	
	combat._process(delta)
	move(delta)
	
	grab_ray.target_position = Vector3(0, 0, -0.7)
	mantle_ray.target_position = Vector3(0, 0, -0.7)
	#feet.target_position = Vector3(0, 0, -1)
	l_wallrun_ray.target_position = Vector3(-0.7, 0, 0)
	r_wallrun_ray.target_position = Vector3(0.7, 0, 0)
	
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

func apply_velocity(speed, delta):
	velocity.z = -cos(rotation.y) * speed
	velocity.x = -sin(rotation.y) * speed

func move_forward(delta, _cam_rotation):
	if(Input.is_action_pressed("move_left")):
		rotation.y = cam.rotation.y + PI/4
	else:
		if Input.is_action_pressed("move_right"):
			rotation.y = cam.rotation.y - PI/4
		else:
			rotation.y = cam.rotation.y
	apply_velocity(PLAYER_SPEED, delta)
	
	
func move_backward(delta, _cam_rotation):
	if(Input.is_action_pressed("move_left")):
		rotation.y = _cam_rotation.y - PI - PI/4
	else:
		if Input.is_action_pressed("move_right"):
			rotation.y = _cam_rotation.y - PI + PI/4
		else:
			rotation.y = _cam_rotation.y - PI
	
	apply_velocity(PLAYER_SPEED, delta)
	

func move_left(delta, _cam_rotation):
	rotation.y = _cam_rotation.y + PI/2
	apply_velocity(PLAYER_SPEED, delta)
	

	
func move_right(delta, _cam_rotation):

	rotation.y = _cam_rotation.y - PI/2
	apply_velocity(PLAYER_SPEED, delta)
	
	
func jump(delta, acceleration):
	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y = 25;	
			
func stop_airtime_velocity(target_rotation, delta) -> bool:
	if !is_on_floor():
		print("player ", rotation.y, ":target ", target_rotation)
		if rotation.y > target_rotation - PI/6 and rotation.y < target_rotation + PI/6:
			apply_velocity(0, delta)
			return true
	return false
		

func dash(delta):
	if dash_timer.is_stopped():
		velocity.z = -cos(rotation.y) * (PLAYER_SPEED + DASH_SPEED) 
		velocity.x = -sin(rotation.y) * (PLAYER_SPEED + DASH_SPEED) 
		dash_timer.start()
	if !dash_timer.is_stopped():
		velocity.z = -cos(rotation.y) * (PLAYER_SPEED + DASH_SPEED) 
		velocity.x = -sin(rotation.y) * (PLAYER_SPEED + DASH_SPEED) 
	
func wallrun(delta):
	var wallrun = l_wallrun_ray.is_colliding() or r_wallrun_ray.is_colliding()
	wall_run_vars["collide"] = wallrun
	if wallrun and !is_on_floor():
		if Input.is_action_pressed("move_backward"):
			wall_run_vars["collide"] = false
			return
			
		if Input.is_action_pressed("jump"):
			if l_wallrun_ray.is_colliding():
				rotation.y += PI/2
				
			if r_wallrun_ray.is_colliding():
				rotation.y -= PI/2	
		velocity.y = -2 
		
		
			
		
		
	
func wall_grapple(delta, acceleration):
	
	var state = grab_ray.is_colliding()
	if !is_on_floor():
		if state and wall_jump_vars["wall"] != grab_ray.get_collider_rid():
			var normal: Vector3 = grab_ray.get_collision_normal()
		
			rotation.y = atan2(normal.x, normal.z)
			velocity.y = 0
			velocity.x = 0
			velocity.z = 0	
			if wall_jump_vars["collide"] == false:
				wall_timer.start()
				wall_jump_vars["collide"] = true
			
		if !state or wall_timer.is_stopped():
			wall_jump_vars["collide"] = false
			wall_jump_vars["wall"] = grab_ray.get_collider_rid()
			
		if state and Input.is_action_pressed("jump"):
			wall_jump_vars["wall"] = grab_ray.get_collider_rid()
			rotation.y -= PI
			velocity.y = 25
			apply_velocity(PLAYER_SPEED, delta)
		
		var mantle_state = !mantle_ray.is_colliding()
		if state and mantle_state:
			wall_timer.start()
			if Input.is_action_pressed("move_forward"):
				var displacement = Vector3(-sin(rotation.y), mantle_ray.position.y , -cos(rotation.y))
				position += displacement
			
		if state and Input.is_action_pressed("move_backward"):
			wall_timer.stop()

			
	if is_on_floor():
		wall_jump_vars["wall"] = null
	
		
## Handles basic player movement (even better tho)
func move(delta):
	if is_on_floor():
		velocity.x = 0
		velocity.z = 0
	var fall_acceleration = -9.8 * 10
	var target_velocity = Vector3.ZERO
	var cam_rotation: Vector3 = $CameraPivot.rotation
	
	
	if is_on_floor():
		if Input.is_action_pressed("move_forward"):
			STATIONARY_CONTINUOUS_TURN = false
			origin_rotation = rotation
			move_forward(delta, cam_rotation)
		else:
			if Input.is_action_pressed("move_backward"):
				move_backward(delta, cam_rotation)
			else:
				if Input.is_action_pressed("move_left"):
					move_left(delta, cam_rotation)
				else:
					if Input.is_action_pressed("move_right"):
						move_right(delta, cam_rotation)
					else:
						#velocity.x = 0
						#velocity.z = 0
						
						var rotation_diff = cam_rotation - origin_rotation		
						if(cos(rotation_diff.y) < 0 || STATIONARY_CONTINUOUS_TURN):
							STATIONARY_CONTINUOUS_TURN = true
							rotation.y = cam_rotation.y
	else:
		print(rotation.y, " ",cam.rotation.y)
		if Input.is_action_pressed("move_forward"):
			if abs(rotation.y - cam.rotation.y) > PI/2:
				apply_velocity(5, delta)
		else:
			if Input.is_action_pressed("move_backward"):
				if abs(rotation.y - cam.rotation.y) < PI/2:
					apply_velocity(5, delta)
			else:
				if Input.is_action_pressed("move_left"):
					if rotation.y < cam.rotation.y:
						apply_velocity(5, delta)
				else:
					if Input.is_action_pressed("move_right"):
						if rotation.y > cam.rotation.y:
							apply_velocity(5, delta)
			
		
	if Input.is_action_pressed("dash") or !dash_timer.is_stopped():
		dash(delta)
		
	jump(delta, fall_acceleration)
	wall_grapple(delta, fall_acceleration)		
	wallrun(delta)
	if !wall_jump_vars["collide"] and !wall_run_vars["collide"]:
		velocity.y += (fall_acceleration * delta)

	
		
	move_and_slide()
	
	

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

## Handles basic player movement. 
func old_move(delta):
	
	var fall_acceleration = -9.8 * 10
	var target_velocity = Vector3.ZERO
	var cam_rotation: Vector3 = $CameraPivot.rotation

	
	
	
	if Input.is_action_pressed("move_forward"):
		STATIONARY_CONTINUOUS_TURN = false
		origin_rotation = rotation
		
		if Input.is_action_pressed("move_left"):
			rotation.y = cam_rotation.y + PI/4
	
		else:
			if Input.is_action_pressed("move_right"):
				rotation.y = cam_rotation.y - PI/4
			else:
				rotation.y = cam_rotation.y

			
		velocity.z = -cos(rotation.y) * PLAYER_SPEED
		velocity.x = -sin(rotation.y) * PLAYER_SPEED
	else: 
	
		if Input.is_action_pressed("move_left"):
			rotation.y = cam_rotation.y + PI/2
			velocity.z = -cos(rotation.y) * PLAYER_SPEED
			velocity.x = -sin(rotation.y) * PLAYER_SPEED
		else:
			if Input.is_action_pressed("move_right"):
				rotation.y = cam_rotation.y - PI/2
				velocity.z = -cos(rotation.y) * PLAYER_SPEED
				velocity.x = -sin(rotation.y) * PLAYER_SPEED
			else: 
				if Input.is_action_pressed("move_backward"):
					velocity.z = cos(rotation.y) * 7
					velocity.x = sin(rotation.y) * 7
				else:
					velocity.x = 0
					velocity.z = 0
			
					var rotation_diff = cam_rotation - origin_rotation		
					if(cos(rotation_diff.y) < 0 || STATIONARY_CONTINUOUS_TURN):
						STATIONARY_CONTINUOUS_TURN = true
						rotation.y = cam_rotation.y
		
	
		
	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y += 25;
		
	if(!is_on_floor()):
		velocity.y += (fall_acceleration * delta)
			
	move_and_slide()
	
	
	
