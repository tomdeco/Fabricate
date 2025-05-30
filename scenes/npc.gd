extends NPC

func _init() -> void:
	MAX_HP = 50
	HP = MAX_HP
	nav_agent = NavigationAgent3D.new()
	

func _process(delta: float) -> void:
	if(HP <= 0):
		print("donut dead :(")
		free()
