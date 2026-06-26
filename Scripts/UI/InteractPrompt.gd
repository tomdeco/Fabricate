extends PanelContainer

@onready var player: Player = $"../../.."
var interactingObject: InteractBody
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func isInteractableSelected() -> bool:
	if player.rangedRayCast.get_collider() is InteractBody:
		return true
	else:
		return false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible = true
	if !isInteractableSelected():
		visible = false
		if interactingObject != null:
			interactingObject.dismiss(player)
			interactingObject = null
		return
	var object = player.rangedRayCast.get_collider() as InteractBody
	
	if interactingObject != null:
		visible = false
	
	if Input.is_action_just_pressed("interact") and interactingObject == null:
		interactingObject = object
		interactingObject.interact(player)
			
