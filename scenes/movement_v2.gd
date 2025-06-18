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

func _init(_player) -> void:
	player = _player
	dash_timer = Timer.new() 
	dash_wait_timer = Timer.new()
	wall_timer = Timer.new()
	PLAYER_SPEED = player.parameters[Enums.EntityParameterID.MOVEMENT_SPEED]
	
func process(delta):
	velocity = player.velocity
	
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var move_forward = Input.is_action_pressed("move_forward")
	var move_backward = Input.is_action_pressed("move_backward")
	
	var direction_modifier = -sin(player.cam.rotation.y)
	print(direction_modifier)
	if move_left:
		direction_modifier += 1
	if move_right:
		direction_modifier -= 1
		if move_left:
			direction_modifier += 0
	 
	velocity.x = 0
	velocity.z = 0

	var sign = 0
	if move_forward:
		sign = 1
		velocity.x = PLAYER_SPEED * -sin(player.rotation.y)
		velocity.z = PLAYER_SPEED * -cos(player.rotation.y)
		
	if move_backward:
		sign = -1
		velocity.x = -PLAYER_SPEED * -sin(player.rotation.y)
		velocity.z = -PLAYER_SPEED * -cos(player.rotation.y)

	## Rotate the direction of velocity according to input
	## Then, rotate the player as well
	player.rotation.y = (sign * (PI/4) * direction_modifier)
	#velocity = velocity.rotated(Vector3(0, 1, 0), sign * (PI/4) * direction_modifier)
	
	if !player.is_on_floor():
		velocity.y += -9.81 * 10 * delta
		
	player.velocity = velocity
	player.move_and_slide()
