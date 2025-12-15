extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body is DrunkMaster:
		GameManager.wall_ability_active = true
		queue_free()
