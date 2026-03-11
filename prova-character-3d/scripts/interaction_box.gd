extends Area3D
class_name InteractionBox3D

# --- SEGNALI ---
# (Li teniamo se volessi ancora collegarci logiche complesse in futuro)
signal interacted
signal player_entered
signal player_exited

# --- VARIABILI ---
## Il testo che vuoi mostrare
@onready var tooltip_text: String = "" 

# Riferimento alla Label che hai creato nell'editor
# Assicurati che il percorso "$CanvasLayer/Label" sia corretto!
@onready var ui_label: Label = $CanvasLayer/Label 
@onready var ui_layer: CanvasLayer = $CanvasLayer

var can_press: bool = false

func _ready() -> void:
	# Colleghiamo i segnali interni dell'Area3D
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	add_to_group("interactables")
	
	# All'avvio, nascondiamo subito la scritta
	if ui_layer:
		ui_layer.hide() 
	# (Nascondiamo l'intero CanvasLayer così non blocca i click del mouse)

func _input(event: InputEvent) -> void:
	# Se siamo dentro e premiamo il tasto
	if can_press and Input.is_action_just_pressed("button_pressed_E"):
		interacted.emit()
		if ui_layer:
			ui_layer.hide()
		# Qui potresti anche cambiare il testo, es: "Premuto!"

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		can_press = true
		print("Giocatore entrato")
		
		# Mostriamo la scritta
		if ui_label:
			ui_label.text = tooltip_text
			ui_layer.show()
		
		player_entered.emit(tooltip_text) # Manteniamo il segnale per compatibilità

func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		can_press = false
		print("Giocatore uscito")
		
		# Nascondiamo la scritta
		if ui_layer:
			ui_layer.hide()
			
		player_exited.emit()
