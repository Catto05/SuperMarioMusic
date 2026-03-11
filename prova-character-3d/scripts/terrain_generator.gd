@tool
extends Node3D
class_name TerrainGenerator

@export var terrain_scene: PackedScene
# Definiamo quanto è grande un chunk (in metri) manualmente per sicurezza
@export var chunk_size: float = 10.0:
	set(value):
		chunk_size = value
		spawn_terrains()

# Ray ora rappresenta il "raggio" in numero di chunk (es. 2 = griglia 5x5)
@export var render_distance: int = 1:
	set(value):
		render_distance = value
		spawn_terrains()

func _ready() -> void:
	if not Engine.is_editor_hint():
		spawn_terrains()

func spawn_terrains():
	# Controllo di sicurezza
	if terrain_scene == null:
		print("Nessuna scena terreno assegnata!")
		return

	# 1. Pulizia esistente immediata
	# Iteriamo al contrario o usiamo una lista separata per sicurezza
	var children = get_children()
	for child in children:
		remove_child(child) # Rimuove dalla gerarchia
		child.queue_free()  # Mette in coda per l'eliminazione

	# 2. Generazione Griglia
	# Usiamo un doppio loop da -distanza a +distanza per centrare la griglia
	for x in range(-render_distance, render_distance + 1):
		for z in range(-render_distance, render_distance + 1):
			_spawn_chunk(x, z)
	
	print("Terreni generati: ", get_children().size())

func _spawn_chunk(x_coord: int, z_coord: int):
	var terrain_instance = terrain_scene.instantiate()
	add_child(terrain_instance)
	
	# Calcola la posizione basata sulle coordinate della griglia e la grandezza del chunk
	var new_pos = Vector3(x_coord * chunk_size, 0, z_coord * chunk_size)
	terrain_instance.position = new_pos
