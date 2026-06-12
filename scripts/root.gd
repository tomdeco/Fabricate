extends Node3D

var noclip: bool = false

var item_list: Item_List


func _init() -> void:
	item_list = Item_List.new()
	
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
	Console.add_command("consume_list", c_list_consume, [], 0, "Lists all available consumables in the game")
	Console.add_command("give_c", c_give_consume, ["item_name"], 1, "TEMPORARY FUNCTION, gives consumable")
	Console.add_command("give_clonites", c_give_clonites, ["amount"], 1, "Give the player a specified amount of clonites")
	Console.add_command("noclip", c_noclip)
	Console.add_command("toggle_hivemind", c_toggle_hivemind, [], 0, "Toggle Hivemind AI simulation")
	
func c_version():
	Console.print_line("Fabricate Pre-Alpha")
	
func c_give_item(name: String):
	var player: Player = $Player
	var item = item_list.getWeapon(name)
	#player.equip(item)
	player.addToInventory(item)
	
func c_give_consume(name: String):
	var player: Player = $Player
	var item = item_list.getConsume(name)
	#player.equip(item)
	player.addToInventory(item)
	
func c_list_weapons():
	for wep in item_list.weapon_list:
		var str = wep.id + " ," + wep.type
		Console.print_line(str)
		
func c_list_consume():
	for consume: Consumable in item_list.consumable_list:
		var str = consume.id
		Console.print_line(str)
		
func c_give_clonites(amount):
	var player: Player = $Player
	player.addClonites(int(amount))
	var str = "Gave player " + amount + " clonites"
	Console.print_line(str)
	
func c_noclip():
	if noclip:
		Console.print_line("noclip disabled")
		noclip = false
	else:
		Console.print_line("noclip enabled")
		noclip = true
		
func c_toggle_hivemind():
	Hivemind.enabled = !Hivemind.enabled
	if Hivemind.enabled:
		Console.print_line("Hivemind AI has been enabled")
	else:
		Console.print_line("Hivemind AI has been disabled")

	
