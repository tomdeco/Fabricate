extends Node3D
var rot_x = 0
var rot_y = 0
var MOUSE_OVERRIDE = false

func _process(delta: float) -> void:
	if !MOUSE_OVERRIDE:
		if Input.is_action_pressed("move_right"):
			rotation.y -= (PI/2 * delta)
			
		if Input.is_action_pressed("move_left"):
			rotation.y += (PI/2 * delta)

func _input(event):
	MOUSE_OVERRIDE = false
	if event is InputEventMouseMotion:
		MOUSE_OVERRIDE = true
		# modify accumulated mouse rotation
		rot_x += event.relative.x * 0.01
		rot_y += event.relative.y * 0.01
		
		if(rot_y > 1):
			rot_y = 1
			
		if(rot_y < -0.45):
			rot_y = -0.45
		
		transform.basis = Basis() # reset rotation
		rotate_object_local(Vector3(0, -1, 0), rot_x)
		rotate_object_local(Vector3(-1, 0, 0), rot_y) # then rotate in X
	
		if(abs(rot_x) > 2*PI):
			rot_x = 0
		
			
