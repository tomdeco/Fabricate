extends NPC

func _init() -> void:
	MAX_HP = 5
	HP = MAX_HP
	
func _process(delta: float) -> void:
	if(HP <= 0):
		print("donut dead :(")
		free()
