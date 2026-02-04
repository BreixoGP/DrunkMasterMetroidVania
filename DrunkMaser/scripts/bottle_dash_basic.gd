extends Area2D
@export var pickup_id: String

func _ready():
	if pickup_id == "":
		push_error("Pickup sin ID: " + name)
		return

	if GameManager.is_pickup_collected(pickup_id):
		queue_free()

func _on_body_entered(body):
	if body is DrunkMaster:
		GameManager.dash_ability_active = true
		GameManager.collect_pickup(pickup_id)
		GameManager.hud.show_message("Drunken Step
A sudden slip of the feet,
escaping before the blow lands.")
		queue_free()
