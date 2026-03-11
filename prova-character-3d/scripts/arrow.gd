extends Node3D

# Configura quanto veloce e quanto ampia è la fluttuazione
@export var float_speed: float = 2.0  # Velocità: Più alto = più frenetico
@export var float_height: float = 0.5 # Ampiezza: Quanto si sposta (in metri)

var initial_y: float
var time_passed: float = 0.0 # Questa variabile accumulerà il tempo

func _ready() -> void:
	# Di solito si fluttua su Y (alto/basso), non Z (avanti/indietro)
	# Se volevi proprio Z, cambia .y in .z qui sotto
	initial_y = position.y 

func _process(delta: float) -> void:
	# 1. Aumentiamo il contatore del tempo
	time_passed += delta 
	
	# 2. Calcoliamo la nuova posizione
	# sin(tempo * velocità) crea l'onda che va da -1 a 1
	# Moltiplichiamo per l'altezza per decidere quanto spostarci
	var new_y = initial_y + sin(time_passed * float_speed) * float_height
	
	# 3. Applichiamo la posizione
	position.y = new_y
