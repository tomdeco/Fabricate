extends CharacterBody3D

@onready var animator = get_node("model/AnimationTree")

## Player constant velocity (in meters per second).
var PLAYER_SPEED = 10

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

func _init():
	combat = Combat.new(self, 0.5)
	

func _ready() -> void:
	setWeapon("Sword", "MELEE")
	
	

func _physics_process(delta: float) -> void:
	combat._process(delta)
	move(delta)
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
		animator.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)			

func apply_velocity(delta):
	velocity.z = -cos(rotation.y) * PLAYER_SPEED
	velocity.x = -sin(rotation.y) * PLAYER_SPEED

func move_forward(delta, _cam_rotation):
	if(Input.is_action_pressed("move_left")):
		rotation.y = _cam_rotation.y + PI/4
	else:
		if Input.is_action_pressed("move_right"):
			rotation.y = _cam_rotation.y - PI/4
		else:
			rotation.y = _cam_rotation.y
	apply_velocity(delta)
	
func move_backward(delta, _cam_rotation):
	if(Input.is_action_pressed("move_left")):
		rotation.y = _cam_rotation.y - PI - PI/4
	else:
		if Input.is_action_pressed("move_right"):
			rotation.y = _cam_rotation.y - PI + PI/4
		else:
			rotation.y = _cam_rotation.y - PI
	apply_velocity(delta)

func move_left(delta, _cam_rotation):
	rotation.y = _cam_rotation.y + PI/2
	apply_velocity(delta)
	
func move_right(delta, _cam_rotation):
	rotation.y = _cam_rotation.y - PI/2
	apply_velocity(delta)

## Handles basic player movement (even better tho)
func move(delta):
	var fall_acceleration = -9.8 * 10
	var target_velocity = Vector3.ZERO
	var cam_rotation: Vector3 = $CameraPivot.rotation
	
	
	
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
					velocity.x = 0
					velocity.z = 0
					
					var rotation_diff = cam_rotation - origin_rotation		
					if(cos(rotation_diff.y) < 0 || STATIONARY_CONTINUOUS_TURN || !is_on_floor()):
						STATIONARY_CONTINUOUS_TURN = true
						rotation.y = cam_rotation.y
					
	if Input.is_action_pressed("jump") && is_on_floor():
		velocity.y += 25;
		
	if(!is_on_floor()):
		velocity.y += (fall_acceleration * delta)
		
	move_and_slide()

func attack(delta: float):
	if Input.is_action_pressed("attack"):
		if combat.EQUIPPED_WEAPON.type == "MELEE":
			var hitbox: Area3D = equipped_weapon_mesh.get_child(1)
			combat.melee_attack(hitbox)
		
	if Input.is_action_pressed("shoulder_view"):
		removeWeapon()
		

func setWeapon(name: String, type: String):
	removeWeapon()
	
	var weplist = $"..".weapon_list as WeaponList
	var weapon: Weapon = weplist.getWeapon("Sword", "MELEE")
	
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
	
	
	
