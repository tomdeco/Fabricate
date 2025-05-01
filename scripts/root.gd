extends Node3D

var weapon_list: WeaponList


func _init() -> void:
	weapon_list = WeaponList.new()
	
	
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(delta: float) -> void:
	if Input.is_action_pressed("pause"):
		get_tree().quit()
		
	if Input.is_action_pressed("debug_reset"):
		get_tree().reload_current_scene()
