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

## The calculated velocity of the player
var velocity: Vector3

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
		if KBM_Controls[idx]:
			MOVE = true
	
func set_direction() -> Vector3: 
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
	
func process(delta):
	velocity = player.velocity
	
	set_movement_flags()
	var direction_modifier = set_direction()
	player.rotation.y = (direction_modifier.y)
	velocity.x = 0
	velocity.z = 0
	
	
	if MOVE:
		velocity.z = -PLAYER_SPEED
		
	if KBM_Controls[Enums.DiscreteMovementFlag.JUMP] and player.is_on_floor():
		var normal = player.get_floor_angle()
		velocity.z = -20
		velocity = velocity.rotated(Vector3(1, 0, 0), normal + PI/2)
	velocity = velocity.rotated(Vector3(0, 1, 0), direction_modifier.y)
	
	

	
	if !player.is_on_floor():
		velocity.y += -9.81 * 10 * delta

		
	player.velocity = velocity
	player.move_and_slide()
