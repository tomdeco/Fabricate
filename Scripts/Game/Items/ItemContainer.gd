@tool
@icon("res://textures/container.svg")
extends InteractBody
## In-game objects that contain items (treasure chests, filing cabinets, etc)
class_name ItemContainer

@export var items: Array[Item] = []

func draw_editor_icon():
	var icon = Sprite3D.new()
	var tex = GradientTexture2D.new()
	tex = load("res://textures/container.svg")
	icon.texture = tex
	icon.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
	icon.set_draw_flag(SpriteBase3D.FLAG_DISABLE_DEPTH_TEST, true)		
	self.add_child(icon)
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		draw_editor_icon()

func interact(player: Player):
	var storage_ui: HoveringStorageInterface = player.hud.hoveringStorage
	storage_ui.setContainer(self)
	for item in items:
		storage_ui.contents.add_item(item.name)	
	storage_ui.contents.select(0)
	storage_ui.visible = true
		
		
		#var storage_item: StorageItem = StorageItem.new()
		#var scene = preload("res://Scene/Assets/UI/StorageItem.tscn").instantiate()
		#storage_ui.contents.add_child(storage_item)
		#for child in scene.get_children():
			#scene.remove_child(child)
			#storage_item.add_child(child)
		#storage_item._ready()
		#storage_item.init(item)
	
		
	
func dismiss(player: Player):
	var storage_ui: HoveringStorageInterface = player.hud.hoveringStorage
	storage_ui.contents.clear()
	storage_ui.visible = false
	
