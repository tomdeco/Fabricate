extends Node3D


func _process(delta: float) -> void:
	if get_children().size() == 0:
		var donut = $"../Donut"
		donut.instantiate()
