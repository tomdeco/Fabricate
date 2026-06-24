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
var external_forces: Vector3 = Vector3(0, 0, 0)

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
	
func setAppliedVelocity(delta: float):
	var direction_modifier = set_direction_kbm()
	
	if MOVE:
		## Ramp up applied player speed, instead of instant speed
		var applied_speed: Vector3 = Vector3(0, 0, -1)
		if dash_timer.time_left > 0:
			applied_speed.z = calculateDash(applied_speed.z, delta)
		
		if applied_velocity.length() < player.parameters[Enums.EntityParameterID.MOVEMENT_SPEED]:	
			var ramp: float = delta * 5
			applied_speed *= (player.parameters[Enums.EntityParameterID.MOVEMENT_SPEED] * ramp)
			applied_velocity += applied_speed.rotated(Vector3(0, 1, 0), direction_modifier.y)
		else:
			applied_speed *= (player.parameters[Enums.EntityParameterID.MOVEMENT_SPEED])
			applied_velocity = applied_speed.rotated(Vector3(0, 1, 0), direction_modifier.y)
			
		
	else:
		applied_velocity = Vector3.ZERO

func checkFlatPlane(plane: Vector3) -> bool:
	var angle = atan2(plane.z, plane.x)
	if angle == 0:
		return true
	return false
	

## Add external forces to player speed
func calculate_external_forces(delta: float):
	#var external_forces: Vector3 = Vector3(0, 0, 0)
	var direction_modifier = set_direction_kbm()
	
	apply_drag(delta)
	apply_slope_speed(delta)
	
	if player.is_on_wall():
		external_forces.x = 0
		external_forces.z = 0
	
	## Add negative vertical velocity when falling
	if !player.is_on_floor():
		external_forces.y += -9.81 * 10 * delta
	else:
		if player.currentFloorAngle == 0.0:
			external_forces.y = 0
		
		
	if KBM_Controls[Enums.DiscreteMovementFlag.JUMP] and player.is_on_floor():
		external_forces.y = 30
		
## Apply friction/drag to the player, so they slow down
func apply_drag(delta: float):
	var direction = set_direction_kbm()
	var angle = player.currentFloorAngle
	var top_speed = 60
	var slope_speed: float = 1 + (angle * top_speed) / (PI/2)
	
	var horizontal_velocity: Vector2 = Vector2(player.velocity.x, player.velocity.z)
	if horizontal_velocity.length() > 10:
		var velocity_decrease: Vector3 = Vector3(0, 0, 1) * 10 * delta
		velocity_decrease = velocity_decrease.rotated(Vector3(0, 1, 0), direction.y)
		external_forces += velocity_decrease
	else:
		external_forces.x = 0
		external_forces.z = 0

## Apply force on the player based on the slope of the floor
func apply_slope_speed(delta: float):
	if player.currentFloorAngle < 0.0:
		var slope_speed_component = 120
		var slope_modifier = (player.currentFloorAngle * slope_speed_component) / 90.0
		var slope_vector: Vector3 = Vector3(0, 1, 0) * slope_modifier
		slope_vector = slope_vector.rotated(Vector3(1, 0, 0), player.currentFloorAngle)
		external_forces += slope_vector.rotated(Vector3(0, 1, 0), player.rotation.y + PI)

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
			
func detectFloorAngleChange():
	var norm: Vector3 = player.get_floor_normal() 
	var angle: float = acos(norm.dot(Vector3(0, 0, -1).rotated(Vector3.UP, player.rotation.y))) - PI/2
	if angle != player.currentFloorAngle:
		print("New floor angle detected")
		player.floor_max_angle = player.get_floor_angle() + PI/4
		player.currentFloorAngle = angle
		player.currentFloorNorm = norm
		#external_forces.rotated(Vector3(-1, 0, 0), angle)
	if not player.is_on_floor():
		player.floor_max_angle = PI/4
	
	


func _input(event: InputEvent):
	set_camera_kbm(event)

func process(delta):
	set_movement_flags()
	detectFloorAngleChange()
	setAppliedVelocity(delta)
	
	
	
	if KBM_Controls[Enums.DiscreteMovementFlag.DASH] and dash_timer.is_stopped():
		dash_timer.start()
		
	player.velocity = (applied_velocity + external_forces)
	player.move_and_slide()
	calculate_external_forces(delta)
	player.velocity.y = applied_velocity.y + external_forces.y
