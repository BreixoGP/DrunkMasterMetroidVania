extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name=="Jahmurai":
		var jahmurai:Jahmurai = body as Jahmurai
		jahmurai.get_damage(jahmurai.life)
		
