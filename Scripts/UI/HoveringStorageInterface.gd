extends PanelContainer
class_name HoveringStorageInterface

@onready var player: Player = $"../../.."
@onready var contents: ItemList = $VBoxContainer/Contents
var container: ItemContainer

func _process(delta: float) -> void:
	if !visible:
		return
	
	if contents.item_count > 0:
		selectItems()
	if Input.is_action_just_pressed("take_all"):
		for item in container.items:
			player.addToInventory(item)
			contents.clear()
			contents.deselect_all()
			container.items.clear()
	
	if Input.is_action_just_pressed("interact"):
		getItem(contents.get_selected_items()[0])
	
func setContainer(_container: ItemContainer):
	container = _container 
	
func getItem(idx: int):
	player.addToInventory(container.items[idx])
	container.items.remove_at(idx)
	contents.remove_item(idx)
	contents.deselect_all()
	
	if idx == 0:
		contents.select(idx)
		return
	else:
		contents.select(idx - 1)
	
func selectItems():
	var selection: int
	if Input.is_action_just_pressed("selection_down"):
		var currentSelection = contents.get_selected_items()[0]
		selection = currentSelection + 1
		if selection >= contents.item_count - 1:
			selection = contents.item_count - 1
		contents.select(selection)

	if Input.is_action_just_pressed("selection_up"):
		var currentSelection = contents.get_selected_items()[0]
		selection = currentSelection - 1
		if selection <= 0:
			selection = 0
		contents.select(selection)
