extends CanvasLayer

@onready var player = $".."

#func _ready() -> void:
	#var window_size = get_viewport().size
	#$HUD.size = window_size
	
func update_hud():
	update_hp(player.get_hp())
	update_speed($"..".velocity.length())
	update_clonite_count(player.parameters[Enums.EntityParameterID.CLONITES])
	set_equip_icon($"..".equipped_item.icon)

func update_hp(hp):
	$HUD/Params/HP/hp_label2.text = str(hp)

func update_speed(speed):
	$HUD/Params/Speed/speed.text = str(speed)
	
func update_clonite_count(count):
	$Inventory/LabelPanel/CloniteCount.text = str(count)

func set_equip_icon(tex):
	$HUD/Params/EquipIcon/TextureRect.texture = tex
