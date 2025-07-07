extends Node

class_name Movement

## Handle all timing and related functions for the dash ability 
var dash_timer: Timer

## Time to wait after dashing
var dash_wait_timer: Timer

var wall_timer: Timer

var player: Player
var PLAYER_SPEED
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
	Enums.DiscreteMovementFlag.JUMP: false
}

var move_forward: bool
var move_backward: bool
var move_left: bool
var move_right: bool
var move: bool

func _init(_player) -> void:
	player = _player
	dash_timer = Timer.new() 
	dash_wait_timer = Timer.new()
	wall_timer = Timer.new()
	PLAYER_SPEED = player.parameters[Enums.EntityParameterID.MOVEMENT_SPEED]
	
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
			if KBM_Controls[Enums.DiscreteMovementFlag.RIGHT]:
				direction.y -= 0.5
					
	
	direction *= PI
	direction.y += player.cam.rotation.y
	return direction
	
## Set the players trajectory using continuous, analog controller input
## NOT CURRENTLTY IMPLEMENTED
func set_direction_controller():
	pass
	
## Calculate the real velocity of the player based on external forces and factors
func calculate_real_velocity(delta: float):
	var angle = player.get_floor_angle()
	var normal = player.get_floor_normal()
	normal.y -= PI/2
	
	## Stop the player when they hit a wall		
	if player.is_on_wall():
		real_velocity.x = 0
		real_velocity.z = 0
	
	## Add negative vertical velocity when falling
	if !player.is_on_floor():
		real_velocity.y += -9.81 * 10 * delta
	else:
		
		## Add negative velocity based on the normal of the floor
		var norm: Vector3 = player.get_floor_normal() - Vector3.UP
		if norm.length() == 0:
			## Reset the vertical component to 0 when on a flat surface
			real_velocity.y = 0
			
			## If the real horizontal velocity becomes less than the base player speed, set real horizontal velocity to zero
			var horizontal_magnitude = Vector2(real_velocity.x, real_velocity.z).length()
			if horizontal_magnitude < PLAYER_SPEED:
				real_velocity.x = 0
				real_velocity.z = 0
			
			## Add friction (decceleration) when on a flat surface
			var speed_loss = real_velocity.normalized() * 5.0 * delta
			real_velocity -= speed_loss 
			
			
		else:
			real_velocity += normal * 9.81 * 10 * delta
			
	return 	real_velocity

func process(delta):
	
	set_movement_flags()
	var direction_modifier = set_direction_kbm()
	player.rotation.y = (direction_modifier.y)
	applied_velocity.x = 0
	applied_velocity.z = 0
	
	real_velocity = calculate_real_velocity(delta)
	
	if MOVE:
		applied_velocity.z = -PLAYER_SPEED
	
	applied_velocity = applied_velocity.rotated(Vector3(0, 1, 0), direction_modifier.y)
	if KBM_Controls[Enums.DiscreteMovementFlag.JUMP] and player.is_on_floor():
		real_velocity.y += 20

	var total_velocity = applied_velocity + real_velocity
	player.velocity = total_velocity
	player.move_and_slide()
