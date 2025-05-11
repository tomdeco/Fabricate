extends Control

@onready var item_container = $ItemContainer
@onready var player = $"../../.."

func add_to_container(item: Item):
	
	## THIS SHOULD BE HANDLED IN THE INVENTORY CLASS, NOT THE UI CLASS!!
	if item_container.get_child_count() == 10:
		print('Player inventory full!')
		return 
	
	var idx = 0
	var rect: Rect2
	var full = true
	for state in item_container.slot_empty_states:
		if item_container.slot_empty_states[state] and item.size == 1:
			rect = item_container.slot_rects[str(idx)]
			item_container.slot_empty_states[str(idx)] = false
			full = false
			break
		if item_container.slot_empty_states[state] and item.size == 2:
			if idx % 2 == 0 and item_container.slot_empty_states[str(idx + 1)]:
				rect = item_container.slot_rects[str(idx)]
				item_container.slot_empty_states[str(idx)] = false
				item_container.slot_empty_states[str(idx + 1)] = false
				full = false
				break;
		idx += 1
	
	if full:
		print('Not enough space!')
		return
	
	var b_item: EquipButton = EquipButton.new(item, rect)
	b_item.pressed.connect(_button_pressed.bind(item))
	b_item.expand_icon = true
	b_item.custom_minimum_size = Vector2(item_container.SLOT_WIDTH * item.size, item_container.SLOT_WIDTH)
	item_container.add_child(b_item)
	item_container.fit_child_in_rect(b_item, b_item.rect)
	
func _button_pressed(item):
	if item is Weapon:
		player.equip(item)
