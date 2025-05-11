extends CanvasLayer

@onready var params: EntityParams = $"..".params

#func _ready() -> void:
	#var window_size = get_viewport().size
	#$HUD.size = window_size

func _process(delta: float) -> void:
	update_hp($"..".params.hp)
	update_speed($"..".velocity.length())
	set_equip_icon(params.equipped_item.icon)

func update_hp(hp):
	$HUD/Params/HP/hp_label2.text = str(hp)

func update_speed(speed):
	$HUD/Params/Speed/speed.text = str(speed)

func set_equip_icon(tex):
	$HUD/Params/EquipIcon/TextureRect.texture = tex
