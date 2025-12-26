extends Area2D
class_name Crystal
@export var pickup_id: String
signal picked_up

func _ready():
	var key = GameManager.current_level.name + ":" + pickup_id
	if GameManager.collected_pickups.has(key):
		queue_free()

func _on_body_entered(body):
	if body is DrunkMaster:
		emit_signal("picked_up")
		var key = GameManager.current_level.name + ":" + pickup_id
		GameManager.collected_pickups[key] = true
		queue_free()
