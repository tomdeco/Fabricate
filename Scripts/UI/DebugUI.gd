extends PanelContainer
class_name DebugUI

@onready var player: Player = $"../../.."

func update():
	update_velocity()
	update_collision()

func update_velocity():
	$VBoxContainer/Velocity/x.text = "X: {}".format([player.velocity.x], "{}")
	$VBoxContainer/Velocity/y.text = "Y: {}".format([player.velocity.y], "{}")
	$VBoxContainer/Velocity/z.text = "Z: {}".format([player.velocity.z], "{}")

func update_collision():
	if player.is_on_floor():
		$VBoxContainer/Collision/floor.text = "Floor collision: True"
	else:
		$VBoxContainer/Collision/floor.text = "Floor collision: False"
		
	if player.is_on_wall():
		$VBoxContainer/Collision/wall.text = "Wall collision: True"
	else:
		$VBoxContainer/Collision/wall.text = "Wall collision: False"
		
	$VBoxContainer/Collision/angle.text = "Floor Angle (radians): %f \nFloor Angle (degrees): %f" % [player.currentFloorAngle, rad_to_deg(player.currentFloorAngle)]
