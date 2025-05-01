extends Node

class_name Movement

## Player constant velocity (in meters per second).
var PLAYER_SPEED

## The speed added by dashing
var DASH_SPEED = 10

## The player velocity before external forces such as gravity or momentum
var inital_velocity: Vector3

## The current velocity of the player. All changes made to player speed are made through here, and then applied to its root node 
var current_velocity: Vector3

var ACCELERATION: float = 0

## Handle all timing and related functions for the dash ability 
var dash_timer: Timer

## Time to wait after dashing
var dash_wait_timer: Timer

var wall_timer: Timer

## Ray Cast Object. Detect grabbable walls
var grab_ray: RayCast3D
var mantle_ray: RayCast3D
var l_wallrun_ray: RayCast3D
var r_wallrun_ray: RayCast3D
var floor_ray: RayCast3D

var isWallGrabbed = false
var isWallGrabDisabled = false
var isAutoGrabbingEnabled = false
var isWallRunning = false
var isOnRamp = false

var currentNormal = Vector3(0, 1, 0)

## Original rotation from last time the player is non-stationary.
var origin_rotation

## Whether the camera acts as free-look or crosshair.
var STATIONARY_CONTINUOUS_TURN = false 

var player: Player

func _init(_player) -> void:
	player = _player
	dash_timer = Timer.new() 
	dash_wait_timer = Timer.new()
	wall_timer = Timer.new()
	PLAYER_SPEED = player.params.MOVEMENT_SPEED

func _ready() -> void:
	setRays()
	dash_timer = Timer.new() 
	dash_wait_timer = Timer.new()
	wall_timer = Timer.new()
	initalizeTimers()

func initalizeTimers():
	# Dash Timer
	dash_timer.one_shot = true
	dash_timer.wait_time = 0.25
	dash_timer.stop()
	add_child(dash_timer)
	
	# Dash Wait Timer
	dash_wait_timer.one_shot = true
	dash_wait_timer.wait_time = 1 + dash_timer.wait_time
	dash_wait_timer.stop()
	add_child(dash_wait_timer)
	
	# Wall-jump Timer
	wall_timer.one_shot = true
	wall_timer.wait_time = 1.5
	add_child(wall_timer)
	

func setRays():
	grab_ray = $"../Rays/Wall Grab"
	mantle_ray = $"../Rays/Mantle"
	l_wallrun_ray = $"../Rays/WallRunLeft"
	r_wallrun_ray = $"../Rays/WallRunRight"
	floor_ray = $"../Rays/Floor"
	
	grab_ray.target_position = Vector3(0, 0, -0.5)
	mantle_ray.target_position = Vector3(0, 0, -0.7)
	l_wallrun_ray.target_position = Vector3(-1.0, 0, 0)
	r_wallrun_ray.target_position = Vector3(1.0, 0, 0)
	floor_ray.target_position = Vector3(0, -1.0, 0)

func add_initial_velocity(direction: Vector3, speed: float):
	inital_velocity.x = direction.x * speed
	inital_velocity.y = direction.y * speed
	inital_velocity.z = direction.z * speed

func add_velocity(direction: Vector3, speed: float):

	current_velocity.x += direction.x * speed
	current_velocity.y += direction.y * speed
	current_velocity.z += direction.z * speed
	
func move_forward(delta, player):
	if(Input.is_action_pressed("move_left")):
		player.rotation.y = player.cam.rotation.y + PI/4
	else:
		if Input.is_action_pressed("move_right"):
			player.rotation.y = player.cam.rotation.y - PI/4
		else:
			player.rotation.y = player.cam.rotation.y
	var direction = Vector3(-sin(player.rotation.y), 0, -cos(player.rotation.y))
	add_initial_velocity(direction, PLAYER_SPEED)
	
	
func move_backward(delta, player):
	
	if abs(current_velocity.length()) > 0:
		current_velocity.x = 0
		current_velocity.z = 0 
		return
	
	if(Input.is_action_pressed("move_left")):
		player.rotation.y = player.cam.rotation.y - PI - PI/4
	else:
		if Input.is_action_pressed("move_right"):
			player.rotation.y = player.cam.rotation.y - PI + PI/4
		else:
			player.rotation.y = player.cam.rotation.y - PI
			
	var direction = Vector3(-sin(player.rotation.y), 0, -cos(player.rotation.y))
	add_initial_velocity(direction, PLAYER_SPEED)
	

func move_left(delta, player):
	player.rotation.y = player.cam.rotation.y + PI/2
	var direction = Vector3(-sin(player.rotation.y), 0, -cos(player.rotation.y))
	add_initial_velocity(direction, PLAYER_SPEED)
	

	
func move_right(delta, player):

	player.rotation.y = player.cam.rotation.y - PI/2
	var direction = Vector3(-sin(player.rotation.y), 0, -cos(player.rotation.y))
	add_initial_velocity(direction, PLAYER_SPEED)
	
	
func jump(delta, acceleration, player):
	if Input.is_action_pressed("jump") and player.is_on_floor():
		add_velocity(currentNormal, 25)	
		#CURRENT_VELOCITY += INITAL_VELOCITY
				
func dash(delta, player: Player):
	var direction = Vector3(-sin(player.rotation.y), 0, -cos(player.rotation.y))
	if dash_wait_timer.is_stopped():
		add_velocity(direction, DASH_SPEED)
		dash_timer.start()
		dash_wait_timer.start()

func wallrun(delta, player: Player):
	#return false
	var leftCollision = l_wallrun_ray.is_colliding()
	var rightCollision = r_wallrun_ray.is_colliding() 
	var isColliding = leftCollision or rightCollision
	var isMoving = false
	
	if current_velocity.x + current_velocity.z != 0:
		isMoving = true
		
	if player.is_on_floor() or !isMoving:
		isWallRunning = false
		return false	
		
	if Vector2(current_velocity.x, current_velocity.z).length() < 20:
		return
	 
	if isMoving and isColliding and !player.is_on_floor():
		isWallRunning = true
	
	if isWallRunning:
		if 	leftCollision:
			var normal: Vector3 = l_wallrun_ray.get_collision_normal()
			player.rotation.y = atan2(normal.x, normal.z) - PI/2
		else:
			var normal: Vector3 = r_wallrun_ray.get_collision_normal()
			player.rotation.y = atan2(normal.x, normal.z) + PI/2
	
		if Input.is_action_pressed("move_backward"):
			isWallRunning = false
			return false
			
		if Input.is_action_pressed("jump"):
			isWallRunning = false
			if leftCollision:
				player.rotation.y -= PI/2
				player.velocity.y = 10
				add_initial_velocity(player.rotation, PLAYER_SPEED)
				
				
			if rightCollision:
				player.rotation.y += PI/2	
				player.velocity.y = 25
				add_initial_velocity(player.rotation, PLAYER_SPEED)
				
			return false
				
		player.velocity.y = -2 
		return true
	return false
			
func wall_grapple(delta, acceleration, player: Player):
	var state = grab_ray.is_colliding()
	if !player.is_on_floor() and !isWallGrabDisabled:
		if (isWallGrabbed and Input.is_action_just_pressed("jump")):
			isWallGrabbed = false
			isAutoGrabbingEnabled = true
			player.rotation.y -= PI
			var direction = Vector3(-sin(player.rotation.y), 0, -cos(player.rotation.y))
			add_velocity(direction, PLAYER_SPEED)
			add_velocity(Vector3(0, 1, 0), 25)
			return
		
		if (state and Input.is_action_just_pressed("jump") and !isWallGrabbed) or (state and isAutoGrabbingEnabled and !isWallGrabbed):
			isWallGrabbed = true
					
		if (isWallGrabbed and state) or (isAutoGrabbingEnabled and state):
			var normal: Vector3 = grab_ray.get_collision_normal()		
			player.rotation.y = atan2(normal.x, normal.z)
			current_velocity = Vector3.ZERO
			
		if Input.is_action_pressed("move_backward"):
			isAutoGrabbingEnabled = false
			isWallGrabbed = false
			isWallGrabDisabled = true
	
	if player.is_on_floor():
		isWallGrabDisabled = false
		isAutoGrabbingEnabled = false
	
	var mantle_state = !mantle_ray.is_colliding()
	if state and mantle_state:
			isWallGrabbed = true
			player.velocity.y = 0
			player.velocity.x = 0
			player.velocity.z = 0	
			if Input.is_action_pressed("move_forward"):
				var displacement = Vector3(-sin(player.rotation.y), mantle_ray.position.y , -cos(player.rotation.y))
				player.position += displacement
				isWallGrabbed = false
				
func applyMomentum(delta, player: Player):
	var direction = Vector3(-sin(player.rotation.y), 0, -cos(player.rotation.y))
	var magnitude = abs(Vector2(current_velocity.x, current_velocity.z).length())
	current_velocity.x = 0
	current_velocity.z = 0
	
	add_velocity(direction, magnitude)
	
	if player.is_on_floor():
		current_velocity.y = 0
		
	if player.is_on_wall():
		var wall = player.get_wall_normal()
		if wall.y == 0:
			currentNormal.x = 0
			currentNormal.z = 0

	if floor_ray.is_colliding():
		var normal = floor_ray.get_collision_normal()
		var diff = cos(player.rotation.z) - normal.y
		if normal.y != 1:
			var vec = Vector3(normal.x, normal.y - 0.5, normal.z)
			var new_vel = magnitude*delta*normal.y
			print(vec)
			
			add_velocity(vec,new_vel)
	
	if player.is_on_floor():
		var decrease = 2 * delta
		var normal_direction = currentNormal.normalized()
		add_velocity(-direction, (magnitude * 0.25 * delta))
		
		if magnitude < PLAYER_SPEED:
			current_velocity.x = 0
			current_velocity.z = 0

## Handles basic player movement (even better tho)
func process(delta, player: Player):		
	var horizontal_acceleration = -9.8 * 5
	var fall_acceleration = -9.8 * 10
	var target_velocity = Vector3.ZERO
	#var cam_rotation: Vector3 = $CameraPivot.rotation
	var direction = Vector3(-sin(player.rotation.y), 0, -cos(player.rotation.y))
	#var magnitude = abs(Vector2(CURRENT_VELOCITY.x, CURRENT_VELOCITY.z).length())
	
	applyMomentum(delta, player)
	
	if player.is_on_floor():	
		if Input.is_action_pressed("move_forward"):
			STATIONARY_CONTINUOUS_TURN = false
			#origin_rotation = rotation
			move_forward(delta, player)
		else:
			if Input.is_action_pressed("move_backward"):
				move_backward(delta, player)
			else:
				if Input.is_action_pressed("move_left"):
					move_left(delta, player)
				else:
					if Input.is_action_pressed("move_right"):
						move_right(delta, player)
					else:	
						inital_velocity = Vector3.ZERO
						var rotation_diff = player.rotation - origin_rotation		
						if(cos(rotation_diff.y) < 0 || STATIONARY_CONTINUOUS_TURN):
							STATIONARY_CONTINUOUS_TURN = true
							player.rotation.y = player.cam.rotation.y
	else:
		current_velocity += inital_velocity
		inital_velocity = Vector3.ZERO
		if Input.is_action_just_pressed("move_forward"):
			if abs(player.rotation.y - player.cam.rotation.y) > PI/2:
				current_velocity.x = current_velocity.x / 2
				current_velocity.z = current_velocity.z / 2
				#add_velocity(direction, 5)
			else: 
				if current_velocity.x + current_velocity.z == 0:
					add_velocity(direction, 5)
		else:
			if Input.is_action_just_pressed("move_backward"):
				if abs(player.rotation.y - player.cam.rotation.y) < PI/2 and current_velocity.x + current_velocity.z > 0:
					current_velocity.x = current_velocity.x / 2
					current_velocity.z = current_velocity.z / 2
					#add_velocity(direction, 5)
			else:
				if Input.is_action_just_pressed("move_left"):
					if player.rotation.y < player.cam.rotation.y:
						current_velocity.x = current_velocity.x / 2
						current_velocity.z = current_velocity.z / 2
						#add_velocity(direction, -5)
				else:
					if Input.is_action_just_pressed("move_right"):
						if player.rotation.y > player.cam.rotation.y:
							current_velocity.x = current_velocity.x / 2
							current_velocity.z = current_velocity.z / 2
							#add_velocity(direction, -5)
			
		
	if Input.is_action_pressed("dash") or !dash_timer.is_stopped():
		dash(delta, player)
		
	jump(delta, fall_acceleration, player)
	wall_grapple(delta, fall_acceleration, player)		

	if !wallrun(delta, player):
		if !isWallGrabbed:
			if !player.is_on_floor():
				add_velocity(Vector3(0, 1, 0), fall_acceleration * delta)
		
				

	player.velocity = inital_velocity + current_velocity	
	player.move_and_slide()
