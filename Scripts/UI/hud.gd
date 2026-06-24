extends CanvasLayer

@onready var player = $".."

#func _ready() -> void:
	#var window_size = get_viewport().size
	#$HUD.size = window_size
	
	
@onready var crosshair = $HUD/Crosshair
	
func setCrosshairPosition():
	var window_size = DisplayServer.window_get_size()
	crosshair.position.x = (window_size.x / 2)
	crosshair.position.y = (window_size.y / 2)
	

func update_hud():
	setCrosshairPosition()
	
	update_hp(player.get_hp())
	update_speed($"..".velocity.length())
	update_clonite_count(player.parameters[Enums.EntityParameterID.CLONITES])
	set_equip_icon($"..".equipped_item.icon)
	
	update_debug_info()

func update_hp(hp):
	$HUD/Params/HP/hp_label2.text = str(hp)

func update_speed(speed):
	$HUD/Params/Speed/speed.text = str(speed)
	
func update_clonite_count(count):
	$Inventory/LabelPanel/CloniteCount.text = str(count)

func set_equip_icon(tex):
	$HUD/Params/EquipIcon/TextureRect.texture = tex
	
func update_debug_info():
	update_debug_velocity(player.velocity)
	update_debug_collision()
	
func update_debug_velocity(velocity: Vector3):
	$HUD/Debug/Velocity/Container/x.text = "X: {}".format([velocity.x], "{}")
	$HUD/Debug/Velocity/Container/y.text = "Y: {}".format([velocity.y], "{}")
	$HUD/Debug/Velocity/Container/z.text = "Z: {}".format([velocity.z], "{}")
	
func update_debug_collision():
	if player.is_on_floor():
		$HUD/Debug/Collision/VBoxContainer/floor.text = "Floor collision: True"
	else:
		$HUD/Debug/Collision/VBoxContainer/floor.text = "Floor collision: False"
		
	if player.is_on_wall():
		$HUD/Debug/Collision/VBoxContainer/wall.text = "Wall collision: True"
	else:
		$HUD/Debug/Collision/VBoxContainer/wall.text = "Wall collision: False"
		
	$HUD/Debug/Collision/VBoxContainer/angle.text = "Floor Angle (radians): %f \nFloor Angle (degrees): %f" % [player.currentFloorAngle, rad_to_deg(player.currentFloorAngle)]
	
	
