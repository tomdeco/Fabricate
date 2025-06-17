@tool
extends Node3D

class_name PatrolRoute

@export var nodes: Array[RouteNode]

## Return the node at index 0. Throws an error if no nodes exist.
func get_head() -> RouteNode:
	var s_name = name
	assert(nodes.size() > 0, s_name + " | There are no RouteNodes present") 
	return nodes[0]
	
func _ready() -> void:
	_add_nodes()
	_link_nodes()
	
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		update_configuration_warnings()

## Store child RouteNodes internally
func _add_nodes():
	for node in get_children():
		nodes.push_back(node)
	
## Link all child nodes into a doubly LinkedList 
func _link_nodes(): 
	var size = nodes.size()
	for idx in range(size):
		if idx == 0:
			nodes[idx].next = nodes[idx + 1]
			nodes[idx].prev = nodes[size - 1]
			continue
		if idx == size - 1:
			nodes[idx].next = nodes[0]
			nodes[idx].prev = nodes[idx - 1]
			continue
			
		nodes[idx].next = nodes[idx + 1]
		nodes[idx].prev = nodes[idx - 1]
		
func _get_configuration_warnings() -> PackedStringArray:
	var warnings = []
	
	var nodes = get_children()
	var routenode_children_exist = false
	for node in nodes:
		if node is RouteNode:
			routenode_children_exist = true
	if !routenode_children_exist:
		warnings.append("PatrolRoute must have atleast one RouteNode child!")
		
	return warnings
