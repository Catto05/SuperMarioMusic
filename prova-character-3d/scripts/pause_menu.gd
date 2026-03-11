extends Control
@onready var resume: Button = $VBoxContainer/resume

func _ready():
	# Nascondiamolo all'inizio del livello
	visible = false 

func _input(event):
	# Se premo ESC (ui_cancel)
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()

func toggle_pause():
	# Inverto lo stato di pausa del gioco
	var stato_pausa = not get_tree().paused
	get_tree().paused = stato_pausa
	
	# Mostro o nascondo il menu
	visible = stato_pausa
	
	# GESTIONE MOUSE (Cruciale per FPS/Rhythm game)
	if stato_pausa:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		# Opzionale: metti il focus sul primo tasto per usare la tastiera
		resume.grab_focus()
	else:
		# Quando riprendi, nascondi il mouse e catturalo per il 3D
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# --- Collegamento dei Bottoni ---\

func _on_resume_pressed() -> void:
	toggle_pause() # Chiama la funzione sopra per chiudere tutto


func _on_quit_pressed() -> void:
	get_tree().quit()
