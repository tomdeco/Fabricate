@tool
extends Node3D

## What NPC to spawn, when, and where. For use with region/level creation

class_name SpawnMarker

var editor_init = false
var icon: Sprite3D

## NPCs will spawn so long as this is true
@export var enabled = true

## Which NPC to spawn
@export var entity: NPCResource

var npc: NPC

## How far the spawner can detect the player. Used in Proximity Mode
@export var detect_range: float

## What signal activates the spawner. Used in Signal Mode
var connection: Signal

@export var mode: Enums.SpawnMarkerModes

@export var weapon: Weapon

var patrol_route: PatrolRoute

signal player_within_vicinity

func _process(delta: float) -> void:
	
	if not enabled:
		return
	
	if Engine.is_editor_hint():
		if !editor_init:
			icon = Sprite3D.new()
			var tex = GradientTexture2D.new()
			tex = load("res://scripts/ai/spawner.tres")
			icon.texture = tex
			self.add_child(icon)
			editor_init = true			
		var cam = EditorInterface.get_editor_viewport_3d().get_camera_3d()
		var direction = (position - cam.position).normalized()
		icon.rotation.y = atan2(direction.x * PI, direction.z * PI)
		
		update_configuration_warnings()
			
		
	if !Engine.is_editor_hint():
		match mode:
			Enums.SpawnMarkerModes.ON_INIT:
				spawn()
			Enums.SpawnMarkerModes.PROXIMITY:
				if check_vicinity(Hivemind.player):
					spawn()

func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	
	var nodes = get_children()
	var patrolnode_child_exists = false
	for node in nodes:
		if node is PatrolRoute:
			patrolnode_child_exists = true
	if !patrolnode_child_exists:
		warnings.append("SpawnMarkers must have a PatrolRoute child!")
		
	return warnings


func spawn():
	enabled = false
	var npc = NPC.new(entity)
	
	var nodes = get_children()
	for node in nodes:
		if node is PatrolRoute:
			patrol_route = node
	
	npc.patrol = patrol_route
	npc.current_routenode = patrol_route.get_head()
	npc.position = position
	npc.equip(weapon)
	
	Hivemind.add_npc(npc)
	add_sibling(npc)
	
func check_vicinity(player: Player):
	if abs(position - player.position) < detect_range:
		player_within_vicinity.emit()
		return true
