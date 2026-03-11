extends Control
@onready var resume: Button = $VBoxContainer/resume
@onready var quit: Button = $VBoxContainer/quit

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	resume.grab_focus()
	
func _on_resume_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/music_island.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
