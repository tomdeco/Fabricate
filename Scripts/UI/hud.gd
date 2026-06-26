extends CanvasLayer
	
@onready var player = $".."
@onready var debug: DebugUI = $Control/Debug
@onready var crosshair = $Control/Crosshair
@onready var inventory_ui: InventoryUI = $Control/Inventory
@onready var parameters: ParameterUI = $Control/Parameters
@onready var hoveringStorage: PanelContainer = $Control/HoveringStorageInterface
	
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
	
	debug.update()

func update_hp(hp):
	parameters.update_hp(hp)

func update_speed(speed):
	parameters.update_speed(speed)

func set_equip_icon(tex):
	parameters.update_equip_icon(tex)
	
func update_clonite_count(count):
	inventory_ui.update_clonite_count(count)


	
