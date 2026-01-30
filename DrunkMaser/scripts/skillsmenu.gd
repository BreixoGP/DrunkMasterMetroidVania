extends Control

@onready var skills_cont: VBoxContainer = $skills_cont
@onready var controls_cont: VBoxContainer = $controls_cont
@onready var wallslide: Node2D = $skills_cont/wallslide
@onready var wallslide_locked: Node2D = $skills_cont/wallslide_locked
@onready var boost: Node2D = $skills_cont/boost
@onready var boost_looked: Node2D = $skills_cont/boost_looked

func _on_controls_pressed() -> void:
	skills_cont.visible = false
	controls_cont.visible =true


func _on_skills_pressed() -> void:
	update_skills_display()
	controls_cont.visible = false
	skills_cont.visible = true

func update_skills_display():
	wallslide.visible = GameManager.wall_ability_active
	wallslide_locked.visible = not GameManager.wall_ability_active
	var has_boost := (GameManager.upgrade_attack_temp + GameManager.upgrade_attack_perm) > 0
	boost.visible = has_boost
	boost_looked.visible = not has_boost
