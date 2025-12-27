extends Area2D

@export var checkpoint_tag: String = "Respawn"
@export var checkpoint_level_path: String = ""

func _on_body_entered(body: Node2D) -> void:
	if body is not DrunkMaster:
		return

	# Determinar nivel del checkpoint
	var level_path := checkpoint_level_path
	if level_path == "":
		level_path = GameManager.current_level_path

	# Activar checkpoint (esto ya convierte temporal → permanente)
	GameManager.activate_checkpoint(level_path, checkpoint_tag)

	# Guardar habilidades permanentes
	GameManager.wall_ability_unlocked = GameManager.wall_ability_active

	print("✅ Checkpoint activado")
	print("Nivel:", level_path)
	print("Spawn:", checkpoint_tag)
	print("Wall ability guardada:", GameManager.wall_ability_unlocked)
