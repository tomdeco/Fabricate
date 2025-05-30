extends Node

## Load and organize all weapons loaded into the game. Includes getters for weapons.

class_name Item_List
var weapon_list = []
var consumable_list = []

var MELEE_WEAPONS = [
	"sword",
	"unarmed"
]

var RANGED_WEAPONS = [
	"revolver"
]

var CONSUMABLES = [
	"s_health"
]

func _init():
	
	var melee_path = "res://resources/weapons/melee/%s.tres"
	for wep in MELEE_WEAPONS:
		var formatted_path = melee_path % wep
		weapon_list.push_back(load(formatted_path))
	
	var ranged_path = "res://resources/weapons/ranged/%s.tres"
	for wep in RANGED_WEAPONS:
		var formatted_path = ranged_path % wep
		weapon_list.push_back(load(formatted_path))
		
	var consumable_path = "res://resources/items/%s.tres"
	for item in CONSUMABLES:
		var formatted_path = consumable_path % item
		consumable_list.push_back(load(formatted_path))

	
func getConsume(id: String):
	for con in consumable_list:
		if id == con.id:
			return con.duplicate()

	
func getWeapon(id: String):
	for wep: Weapon in weapon_list:
		if id == wep.id:
			return wep.duplicate()
