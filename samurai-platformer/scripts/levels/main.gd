extends Node2D
@onready var drunkmaster: DrunkMaster = $DrunkMaster
@onready var fade: ColorRect = $CanvasLayer/Fade
@onready var levelcontainer: Node2D = $levelcontainer


func _ready():
	GameManager.player = drunkmaster
	GameManager.levelcontainer=levelcontainer
	GameManager.fade = fade
	GameManager.load_current_level()
	
