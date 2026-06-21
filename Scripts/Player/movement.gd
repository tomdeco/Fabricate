extends Node

class_name Movement

## Handle all timing and related functions for the dash ability 
var dash_timer: Timer
var dash_length: float = 1.0
var dash_factor: float = 2.0

## Time to wait after dashing
var dash_wait_timer: Timer

var wall_timer: Timer

var player: Player
var origin_rotation

## The velocity of the player based on inputs
var applied_velocity: Vector3

## The velocity of the player based on external, environmental factors
var real_velocity: Vector3

## Discrete Movement Flags (for KB+M controls)
var MOVE: bool = false
var KBM_Controls: Dictionary = {
	Enums.DiscreteMovementFlag.FORWARD: false,
	Enums.DiscreteMovementFlag.BACKWARD: false,
	Enums.DiscreteMovementFlag.LEFT: false,
	Enums.DiscreteMovementFlag.RIGHT: false,
	Enums.DiscreteMovementFlag.JUMP: false,
	Enums.DiscreteMovementFlag.DASH: false
}

var move_forward: bool
var move_backward: bool
var move_left: bool
var move_right: bool
var move: bool

func _init(_player) -> void:
	player = _player
	
	dash_timer = Timer.new() 
	dash_timer.wait_time = dash_length
	dash_timer.one_shot = true
	add_child(dash_timer)
	
	dash_wait_timer = Timer.new()
	wall_timer = Timer.new()
	
## Update all movement related flags for input polling
func set_movement_flags():
	## Reset MOVE to false by default
	MOVE = false
	
	## Set all KBM control flags according to player input
	KBM_Controls[Enums.DiscreteMovementFlag.LEFT] = Input.is_action_pressed("move_left")
	KBM_Controls[Enums.DiscreteMovementFlag.RIGHT] = Input.is_action_pressed("move_right")
	KBM_Controls[Enums.DiscreteMovementFlag.FORWARD] = Input.is_action_pressed("move_forward")
	KBM_Controls[Enums.DiscreteMovementFlag.BACKWARD] = Input.is_action_pressed("move_backward")
	KBM_Controls[Enums.DiscreteMovementFlag.JUMP] = Input.is_action_pressed("jump")
	KBM_Controls[Enums.DiscreteMovementFlag.DASH] = Input.is_action_just_pressed("dash")
	
	## If any movement input is made, MOVE will become true
	for idx in KBM_Controls:
		if KBM_Controls[idx] and idx != Enums.DiscreteMovementFlag.JUMP:
			MOVE = true
	
## Set the direction of the players trajectory using discrete, KB+M controls
func set_direction_kbm() -> Vector3: 
	var direction: Vector3 = Vector3.ZERO
	if KBM_Controls[Enums.DiscreteMovementFlag.FORWARD]:
		direction.y += 0
		if KBM_Controls[Enums.DiscreteMovementFlag.RIGHT]:
			direction.y -= 0.25
		else:
			if KBM_Controls[Enums.DiscreteMovementFlag.LEFT]:
				direction.y += 0.25
	else:			
		if KBM_Controls[Enums.DiscreteMovementFlag.BACKWARD]:
			direction.y -= 1
			if KBM_Controls[Enums.DiscreteMovementFlag.RIGHT]:
				direction.y += 0.25
			else:
				if KBM_Controls[Enums.DiscreteMovementFlag.LEFT]:
					direction.y -= 0.25
		else:
			if KBM_Controls[Enums.DiscreteMovementFlag.LEFT]:
				direction.y += 0.5
			else:
				if KBM_Controls[Enums.DiscreteMovementFlag.RIGHT]:
					direction.y -= 0.5
					
	
	direction *= PI
	direction.y += player.rotation.y
	return direction
	
## Set the players trajectory using continuous, analog controller input
## NOT CURRENTLTY IMPLEMENTED
func set_direction_controller():
	pass
	

func calculateDash(base_velocity: float, delta: float):
	var dash_component = 1 + ((dash_timer.time_left*dash_factor)/dash_length)
	return base_velocity*dash_component
	

## Calculate the real velocity of the player based on external forces and factors
func calculate_real_velocity(delta: float):
	#var angle = player.get_floor_angle()
	#var normal = player.get_floor_normal()
	#normal.y -= PI/2
	#
	### Stop the player when they hit a wall		
	#if player.is_on_wall():
		#real_velocity.x = 0
		#real_velocity.z = 0
	
	## Add negative vertical velocity when falling
	if !player.is_on_floor():
		real_velocity.y += -9.81 * 10 * delta
	else:
		real_velocity.y = 0
	
		
	return 	real_velocity


var rot_x = 0
var rot_y = 0
var MOUSE_OVERRIDE = false

func set_camera_kbm(event: InputEvent):
	MOUSE_OVERRIDE = false
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		MOUSE_OVERRIDE = true
		# modify accumulated mouse rotation
		rot_x += event.relative.x * 0.01
		rot_y += event.relative.y * 0.01
		
		if(rot_y > PI/2):
			rot_y = PI/2
			
		if(rot_y < -PI/2):
			rot_y = -PI/2
		
		player.transform.basis = Basis() # reset rotation
		player.cam.transform.basis = Basis()
		
		player.rotate_object_local(Vector3(0, -1, 0), rot_x)
		player.cam.rotate_object_local(Vector3(0, -1, 0), rot_x)
		player.cam.rotate_object_local(Vector3(-1, 0, 0), rot_y) # then rotate in X
	
		if(abs(rot_x) > 2*PI):
			rot_x = 0
			
func _input(event: InputEvent):
	set_camera_kbm(event)

func process(delta):
	#player.rotation.y = player.cam.rotation.y
	
	set_movement_flags()
	var direction_modifier = set_direction_kbm()
	applied_velocity.x = 0
	applied_velocity.z = 0
	
	
		
	
	real_velocity = calculate_real_velocity(delta)
	
	if KBM_Controls[Enums.DiscreteMovementFlag.DASH] and dash_timer.is_stopped():
		dash_timer.start()
		
	
	if MOVE:
		applied_velocity.z = -player.parameters[Enums.EntityParameterID.MOVEMENT_SPEED]
		if dash_timer.time_left > 0:
			applied_velocity.z = calculateDash(applied_velocity.z, delta)
	
	applied_velocity = applied_velocity.rotated(Vector3(0, 1, 0), direction_modifier.y)
	if KBM_Controls[Enums.DiscreteMovementFlag.JUMP] and player.is_on_floor():
		real_velocity.y = 30
		


	var total_velocity = applied_velocity + real_velocity
	
	player.velocity = total_velocity
	player.move_and_slide()
	
