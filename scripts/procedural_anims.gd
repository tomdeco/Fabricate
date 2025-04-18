extends Skeleton3D

@onready var cam = get_node("../../../CameraPivot")
@onready var player = get_node("../../..")
	
func _process(delta: float) -> void:
	var rotate = Vector3(cam.rotation - player.rotation)
	if(cos(rotate.y) > 0):
		set_bone_pose_rotation(7, Quaternion.from_euler(Vector3(0, rotate.y, 0)))
	
	
	
