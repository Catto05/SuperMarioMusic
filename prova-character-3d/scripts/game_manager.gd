extends Node

#Global vars
var last_position

# --- VARIABILI ---
var collected_npcs: int = 0

# Configurazioni Bullet Time
var normal_time_scale: float = 1.0
var slow_time_scale: float = 0.3   # Fisica rallentata al 10%
var slow_audio_pitch: float = 0.6  # Audio rallentato (0.5 = metà velocità/ottava bassa)
var power_duration: float = 8    # Durata in secondi REALI

# Stato
var is_power_active: bool = false

# Riferimento alla musica (Dovrai assegnarlo!)
var music_player: AudioStreamPlayer

# --- SETUP INIZIALE ---
func _ready() -> void:
	# Se sai dove sta il player musicale dell'addon "Conductor", cercalo qui.
	# Esempio: se Conductor è un Autoload chiamato 'Conductor':
	music_player = Conductor

# --- FUNZIONI ---

func add_collected_npc():
	collected_npcs += 1
	print("NPC Raccolti: ", collected_npcs)

# Questa funzione viene chiamata quando premi il tasto
func activate_slow_motion():
	# Se è già attivo, ignoriamo o resettiamo il timer (qui lo ignoriamo per semplicità)
	if is_power_active:
		return
	if collected_npcs > 0:
		start_bullet_time()
	return

func start_bullet_time():
	is_power_active = true
	if collected_npcs>=1:
		collected_npcs -= 1
	# 1. Rallenta la fisica
	var tween_time = create_tween()
	tween_time.tween_property(Engine, "time_scale", slow_time_scale, 0.2)
	
	# 2. Rallenta la musica (Se abbiamo trovato il player)
	if music_player:
		# Usiamo un Tween per rendere il rallentamento audio graduale (più figo)
		var tween = create_tween()
		tween.tween_property(music_player, "pitch_scale", slow_time_scale, 0.2)
	
	print("Potere Attivato! Tempo rallentato.")
	
	# 3. IL TIMER DEI 5 SECONDI REALI
	# get_tree().create_timer(...) crea un timer al volo.
	# L'ultimo parametro 'true' significa: "Ignora Time Scale" (usa tempo reale)
	await get_tree().create_timer(power_duration, true, false, true).timeout
	
	stop_bullet_time()

func stop_bullet_time():
	# 1. Ripristina fisica
	Engine.time_scale = normal_time_scale
	
	# 2. Ripristina audio
	if music_player:
		var tween = create_tween()
		tween.tween_property(music_player, "pitch_scale", 1.0, 0.2)
	
	is_power_active = false
	print("Potere Finito. Tempo normale.")
	
