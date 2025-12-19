extends Area2D
class_name Crystal

signal picked_up

func _on_body_entered(body):
	if body is DrunkMaster:
		emit_signal("picked_up")
		queue_free()
