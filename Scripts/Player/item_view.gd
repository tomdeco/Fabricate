@tool
extends SubViewportContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	size = DisplayServer.window_get_size()
	$"../ItemViewContainer/ItemView".own_world_3d = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		size = DisplayServer.window_get_size()
		$"../ItemViewContainer/ItemView".own_world_3d = false
		
	if not Engine.is_editor_hint():
		$"../ItemViewContainer/ItemView".own_world_3d = true
	pass
