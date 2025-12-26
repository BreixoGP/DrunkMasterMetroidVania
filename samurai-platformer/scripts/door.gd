extends AnimatedSprite2D
@onready var door: AnimatedSprite2D = $"."


# Called when the node enters the scene tree for the first time.
@export var target_scene := "res://scenes/castle/level_1.tscn"
@export var target_spawn := "Spawn_left"



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "DrunkMaster":
		door.play("open")
		#aqui iria el sonido
		await door.animation_finished
		GameManager.player_spawn_tag = target_spawn
		GameManager.load_level(target_scene)
