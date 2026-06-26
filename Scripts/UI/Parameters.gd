extends Control
class_name ParameterUI

@onready var player = $"../../.."
@onready var hp: Label = $HP/Value
@onready var speed: Label = $Speed/Value
@onready var equipIcon: TextureRect = $EquipIcon/Tex


func update_hp(val):
	hp.text = str(val)
	
func update_speed(val):
	speed.text = str(val)

func update_equip_icon(tex):
	equipIcon.texture = tex
