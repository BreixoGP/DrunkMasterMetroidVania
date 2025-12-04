extends ColorRect

@export var fade_time := 0.75

func fade_from_black():
	# Negro -> transparente
	modulate.a = 1.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, fade_time)
	await tween.finished

func fade_to_black():
	# Transparente -> negro
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, fade_time)
	await tween.finished
