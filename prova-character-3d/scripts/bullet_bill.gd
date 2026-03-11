extends Node3D

# PARAMETRI NELL'INSPECTOR
@export var speed_x: float = 5.0      # Velocità di avanzamento in avanti
@export var radius: float = 2.0       # Quanto è largo il cerchio (ampiezza)
@export var rotation_speed: float = 4.0 # Velocità di rotazione (frequenza)

var time_passed: float = 0.0
var initial_y: float
var initial_z: float

func _ready():
	# Memorizziamo la posizione iniziale Y e Z per ruotare "attorno" a quel punto
	initial_y = position.y
	initial_z = position.z

func _process(delta: float):
	time_passed += delta
	
	# 1. Movimento Rettilineo su X (Avanzamento)
	# Usiamo += per continuare ad avanzare dalla posizione corrente
	position.x += speed_x * delta 
	
	# 2. Movimento Circolare su Y e Z (Rotazione)
	# Qui calcoliamo la posizione assoluta rispetto al centro iniziale
	# Nota: Cos su Y e Sin su Z (o viceversa) creano il cerchio
	position.y = initial_y + cos(time_passed * rotation_speed) * radius
	position.z = initial_z + sin(time_passed * rotation_speed) * radius
