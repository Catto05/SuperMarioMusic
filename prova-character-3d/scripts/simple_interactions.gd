extends Node3D
class_name SimpleInteractable

# --- CONFIGURAZIONE ---
@export_group("Setup")
## Trascina qui l'InteractionBox3D (Area3D)
@export var interaction_zone: InteractionBox3D
## Il testo che apparirà a schermo
@export_multiline var interaction_text: String = "Interagisci"
## Se vero, l'interazione funziona una volta sola (es. raccogliere un oggetto)
@export var one_shot: bool = false

# --- VARIABILI INTERNE ---
var _has_interacted: bool = false

func _ready() -> void:
	# 1. Trova la zona se non è assegnata
	if not interaction_zone:
		_find_interaction_zone_automatically()
	
	# 2. Collega i segnali
	if interaction_zone:
		# Passiamo il testo alla zona così lei lo mostra nella UI
		interaction_zone.tooltip_text = interaction_text
		
		interaction_zone.interacted.connect(_on_base_interacted)
		interaction_zone.player_entered.connect(_on_base_entered)
		interaction_zone.player_exited.connect(_on_base_exited)
	else:
		push_warning("Attenzione: Nessuna InteractionBox trovata su " + name)

# --- LOGICA DI BASE (Non toccare solitamente) ---
func _find_interaction_zone_automatically() -> void:
	for child in get_children():
		if child is InteractionBox3D:
			interaction_zone = child
			break

func _on_base_interacted() -> void:
	if one_shot and _has_interacted:
		return
	
	_has_interacted = true
	interact() # Chiama la funzione personalizzabile

func _on_base_entered(_text_ignorato: String) -> void:
	# Aggiorna il testo ogni volta che entri (utile se il testo cambia dinamicamente)
	interaction_zone.tooltip_text = interaction_text 
	on_enter()

func _on_base_exited() -> void:
	on_exit()

# --- FUNZIONI DA MODIFICARE (OVERRIDE) ---
# Queste sono le funzioni che modificherai negli script figli

## Cosa succede quando premi E
func interact() -> void:
	print("Interazione generica su: " + name)
	# Esempio: Qui potresti mettere un'animazione base

## Cosa succede quando il player entra nell'area (opzionale)
func on_enter() -> void:
	pass

## Cosa succede quando il player esce dall'area (opzionale)
func on_exit() -> void:
	pass
