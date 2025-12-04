extends Node2D
@export var cam_limit_left : int
@export var cam_limit_top : int
@export var cam_limit_right : int
@export var cam_limit_bottom : int


func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func apply_camera_limits(camera: Camera2D):
	camera.limit_left = cam_limit_left
	camera.limit_top = cam_limit_top
	camera.limit_right = cam_limit_right
	camera.limit_bottom = cam_limit_bottom
