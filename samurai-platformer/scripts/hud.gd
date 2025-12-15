extends CanvasLayer

@onready var message_label: Label = $MessageLabel
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
