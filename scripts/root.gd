extends Node3D

var weapon_list: WeaponList


func _init() -> void:
	weapon_list = WeaponList.new()
	
	
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_console_commands()
		
func _process(delta: float) -> void:
	if Input.is_action_pressed("pause"):
		get_tree().quit()
		
	if Input.is_action_pressed("debug_reset"):
		get_tree().reload_current_scene()
		
func set_console_commands():
	Console.pause_enabled = true
	Console.add_command("version", c_version)
	Console.add_command("give", c_give_item, ["item_name"], 1, "Gives the player an item, and adds it to their inventory")
	Console.add_command("weapon_list", c_list_weapons, [], 0, "Lists all available weapons in the game")
	
func c_version():
	Console.print_line("Fabricate Pre-Alpha")
	
func c_give_item(name: String):
	var player: Player = $Player
	var item = weapon_list.getWeapon(name)
	player.equip(item)
	player.addToInventory(item)
	
func c_list_weapons():
	for wep in weapon_list.weapon_list:
		var str = wep.name + " ," + wep.type
		Console.print_line(str)
