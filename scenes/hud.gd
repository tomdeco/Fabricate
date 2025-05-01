extends CanvasLayer

func _process(delta: float) -> void:
	update_hp($"../Player".params.hp)
	update_speed($"../Player".velocity.length())

func update_hp(hp):
	$Control/Panel/hp_label2.text = str(hp)

func update_speed(speed):
	$Control/Panel/speed.text = str(speed)
