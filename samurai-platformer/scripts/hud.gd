extends CanvasLayer

@onready var message_label: Label = $MessageLabel
@onready var life_label: Label = $HBoxContainer/life_label
@onready var points_label: Label = $HBoxContainer/points_label
@onready var anim: AnimatedSprite2D = $HBoxContainer/AnimatedSprite2D

var max_health = 10
var total_frames := 10 

var message_timer: Timer

func _ready():
	if message_label:
		message_label.visible = false

	message_timer = Timer.new()
	message_timer.one_shot = true
	add_child(message_timer)
	message_timer.timeout.connect(_hide_message)

func show_message(text: String, duration := 2.5):
	message_label.text = text
	message_label.visible = true
	message_timer.start(duration)

func _hide_message():
	message_label.visible = false

func update_points():
	points_label.text = str(GameManager.score)
	
func set_max_health(hp: int):
	max_health = hp

func update_health(life):
	anim.play(str(life))
