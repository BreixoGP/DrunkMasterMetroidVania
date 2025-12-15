extends Node2D
@onready var drunkmaster: DrunkMaster = $DrunkMaster
@onready var fade: ColorRect = $CanvasLayer/Fade
@onready var levelcontainer: Node2D = $levelcontainer
@onready var hud: CanvasLayer = $HUD


func _ready():
	GameManager.hud = hud
	GameManager.player = drunkmaster
	GameManager.levelcontainer=levelcontainer
	GameManager.fade = fade
	GameManager.load_current_level()
	GameManager.hud.set_max_health(GameManager.player.life)
	GameManager.hud.update_health(GameManager.player.life)
