extends Resource

## Data for a specific NPC to be used in-game. This should be used when creating NPCs, NOT the NPC node class. 

class_name NPCResource

@export var id: String ## Identifying string
@export var name: String ## Actual name of the NPC
@export var max_health: float ## Maximum acheviable health
@export var base_damage: float ## Applicable to melee only
@export var movement_speed: float ## How fast the NPC moves in m/s
@export var clonites: int ## How many clonites are dropped upon death
@export var npc_scene: PackedScene
@export var ai_mode: Enums.NpcNavigationMode
@export var hand_bone_name: String
@export_flags_3d_navigation var navigation_layer 

#func _init(_id, _name, _max_health, _base_damage, _movement_speed, _clonites, _scene):
	#id = _id
	#name = _name
	#max_health = _max_health
	#base_damage = _base_damage
	#movement_speed = _movement_speed
	#clonites = _clonites
	#scene = _scene
