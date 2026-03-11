extends Label

var update_interval: float = 1.0

var current_update: float = 0.0

func _physics_process(delta: float) -> void:
	current_update += delta
	if current_update >= update_interval:
		current_update = 0
		_update_label()

func _update_label() -> void:
	text = "FPS: {fps}".format({"fps":"%.3f"%Engine.get_frames_per_second()}) 
