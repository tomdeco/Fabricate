extends Control
class_name InventoryUI

@onready var itemFrame = $Background/ItemFrame
@onready var item_container = $Background/ItemFrame/ItemContainer
@onready var player = $"../../.."

func update_clonite_count(count: int):
	$Background/LabelPanel/HBoxContainer/CloniteCount.text = str(count)

func add_to_container(item: Item):
	
	## THIS SHOULD BE HANDLED IN THE INVENTORY CLASS, NOT THE UI CLASS!!
	if item_container.get_child_count() == 12:
		print('Player inventory full!')
		return 
	
	var idx = 0
	var rect: Rect2
	var full = true
	
	if item.size == 1:
		for slot in item_container.slot_empty_states:
			if item_container.slot_empty_states[slot] and idx < 12:
				rect = item_container.slot_rects[str(idx)]
				item_container.slot_empty_states[str(idx)] = false
				full = false
				break
			idx += 1
	else:
		if item.size == 2:
			for slot in item_container.slot_empty_states:
				if item_container.slot_empty_states[slot] and idx % 2 == 0 and idx < 12:
					if item_container.slot_empty_states[str(idx + 1)]:
						rect = item_container.slot_rects[str(idx)]
						item_container.slot_empty_states[str(idx)] = false
						item_container.slot_empty_states[str(idx + 1)] = false
						full = false
						break
				idx += 1
					
	
	#for slot in item_container.slot_empty_states:
		#if item_container.slot_empty_states[slot] and item.size == 1:
			#rect = item_container.slot_rects[str(idx)]
			#item_container.slot_empty_states[str(idx)] = false
			#full = false
			#break
		#if item_container.slot_empty_states[slot] and item.size == 2:
			#if idx % 2 == 0 and item_container.slot_empty_states[str(idx + 1)]:
				#rect = item_container.slot_rects[str(idx)]
				#item_container.slot_empty_states[str(idx)] = false
				#item_container.slot_empty_states[str(idx + 1)] = false
				#full = false
				#break;
		#idx += 1
	
	if full:
		print('Not enough space!')
		return
	
	var b_item: EquipButton = EquipButton.new(item, rect, idx)
	b_item.pressed.connect(_button_pressed.bind(item, b_item))
	b_item.expand_icon = true
	b_item.custom_minimum_size = Vector2(item_container.SLOT_WIDTH * item.size, item_container.SLOT_WIDTH)
	item_container.add_child(b_item)
	item_container.fit_child_in_rect(b_item, b_item.rect)
	
func remove_from_container(button: EquipButton):
	var idx = button.get_index()
	button.queue_free()
	for pos in button.item.size:
		item_container.slot_empty_states[str(button.slot + pos)] = true
	print(item_container.slot_empty_states)

func _button_pressed(item, button):
	if item is not Consumable:
		var stow_item = player.equipped_item
		player.equip(item)
		remove_from_container(button)
		player.addToInventory(stow_item)
		return
	else:
		remove_from_container(button)
		player.addEntityEffect(item)
		player.inventory.remove(item)
		player.inventory.add(player.equipped_item)
