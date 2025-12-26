extends Node2D
@onready var drunkmaster: DrunkMaster = $DrunkMaster
@onready var fade: ColorRect = $CanvasLayer/Fade
@onready var levelcontainer: Node2D = $levelcontainer
@onready var hud: CanvasLayer = $HUD


func _ready():
	GameManager.hud = hud
	GameManager.player = drunkmaster
	GameManager.levelcontainer = levelcontainer
	GameManager.fade = fade
	
	drunkmaster.set_physics_process(false)
	GameManager.load_current_level()
	await get_tree().process_frame
	drunkmaster.set_physics_process(true)
	
	# HUD después de cargar el nivel
	hud.set_max_health(drunkmaster.life)
	hud.update_health(drunkmaster.life)
	hud.update_points()
