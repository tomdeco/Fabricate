@tool
extends Node3D


## RouteNodes are used to make a PatrolRoute. RouteNodes and the edges between them make up a path (either cyclic or acyclic) for an NPC to travel while in patrol mode. 

class_name RouteNode
var editor_init = false
var icon: Sprite3D

## The node directly after this one (forward)
@export var next: RouteNode

## The node directly before this one (backward)
@export var prev: RouteNode

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		if !editor_init:
			icon = Sprite3D.new()
			var tex = GradientTexture2D.new()
			tex = load("res://scripts/ai/patrol_node.tres")
			icon.texture = tex
			self.add_child(icon)
			editor_init = true
			icon.billboard = BaseMaterial3D.BILLBOARD_FIXED_Y
			icon.set_draw_flag(SpriteBase3D.FLAG_DISABLE_DEPTH_TEST, true)		
			
func _ready() -> void:
	top_level = true
