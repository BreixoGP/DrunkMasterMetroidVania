extends Area2D
@export var pickup_id: String

func _ready():
	var key = GameManager.current_level.name + ":" + pickup_id
	if GameManager.collected_pickups.has(key):
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is DrunkMaster:
		GameManager.add_point(20)
		#sonido?
		#await $AudioStreamPlayer2D.finished
		var key = GameManager.current_level.name + ":" + pickup_id
		GameManager.collected_pickups[key] = true
		queue_free()
		
