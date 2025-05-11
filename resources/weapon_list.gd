extends Node

## Load and organize all weapons loaded into the game. Includes getters for weapons.

class_name WeaponList
var weapon_list = []

var MELEE_WEAPONS = [
	"sword",
	"unarmed"
]

var RANGED_WEAPONS = [
	"revolver"
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

	
func getWeapon(name: String):
	for wep: Weapon in weapon_list:
		if name == wep.name:
				return wep.duplicate()
