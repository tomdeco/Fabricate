extends CenterContainer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible = true
	if Input.is_action_pressed("inventory"):
		visible = false
