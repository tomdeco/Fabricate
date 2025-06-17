@tool
extends Node3D


## RouteNodes are used to make a PatrolRoute. RouteNodes and the edges between them make up a path (either cyclic or acyclic) for an NPC to travel while in patrol mode. 

class_name RouteNode
var _editor_init = false
var _icon: Sprite3D

## The node directly after this one (forward)
@export var next: RouteNode

## The node directly before this one (backward)
@export var prev: RouteNode


func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if !_editor_init:
			_icon = Sprite3D.new()
			var tex = GradientTexture2D.new()
			tex = load("res://scripts/ai/patrol_node.tres")
			_icon.texture = tex
			self.add_child(_icon)
			_editor_init = true			
		var cam = EditorInterface.get_editor_viewport_3d().get_camera_3d()
		var direction = (position - cam.position).normalized()
		_icon.rotation.y = atan2(direction.x * PI, direction.z * PI)
