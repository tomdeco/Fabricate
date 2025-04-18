extends Node3D

var weapon_list: WeaponList


func _init() -> void:
	weapon_list = WeaponList.new()
	
	
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
