extends CharacterBody3D

@onready var spring_arm_pivot: Node3D = $spring_arm_3d
@onready var spring_arm: SpringArm3D = $spring_arm_3d/SpringArm3D
@onready var armature: Skeleton3D = $"T-Pose/Skeleton3D"
@onready var animation_player: AnimationPlayer = $"T-Pose/AnimationPlayer"

var has_double_jumped: bool
const JUMP_VELOCITY = 4.5 # Questa costante non sembra usata nel tuo codice dinamico, ma la lascio.

# --- VARIABILI BASE (Per memorizzare i valori originali) ---
var base_max_speed: float
var base_acceleration: float
var base_friction: float
var base_gravity: float
var base_jump_velocity: float
var base_lerp: float
var last_time_scale: float = 1.0 # Per gestire la transizione della velocità
var is_walking : bool = false
var can_hit_goomba : bool = false

@export var LERP_VAL = 10
@export var max_speed: float = 5.0
@export var acceleration: float = 4.0 
@export var friction: float = 5.0

# Gravity variables
var gravity = -9.8
var grounded_gravity = -0.05

# Jump configuration
@export var initial_jump_velocity: float
@export var max_jump_height: float = 1.0
@export var max_jump_time: float = 0.5
var fall_multiplier: float = 1.0 # Inizializzato a 1 per sicurezza
var warp: float

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# 1. Calcoliamo la fisica iniziale
	setup_jump_variables()
	
	# 2. SALVIAMO I VALORI ORIGINALI "PULITI"
	# Questo è fondamentale: salviamo i valori veri prima di iniziare a modificarli
	base_max_speed = max_speed
	base_acceleration = acceleration
	base_friction = friction
	base_gravity = gravity
	base_jump_velocity = initial_jump_velocity
	base_lerp = LERP_VAL

func _unhandled_input(event: InputEvent) -> void:

	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		spring_arm_pivot.rotate_y(-event.relative.x * .002)
		spring_arm.rotate_x(-event.relative.y * .002)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("power_up_key"): 
		GameManager.activate_slow_motion()
	
	# --- INIZIO LOGICA TEMPO REALE ---
	
	# 1. Calcolo del fattore di correzione (Warp)
	# Se il tempo è 0.1 (lento), il warp è 10.0
	var current_scale = Engine.time_scale
	warp = 1.0 / current_scale if current_scale > 0.0 else 1.0
	
	# 2. Gestione Transizione Velocità (Anti-Jitter)
	# Se il tempo cambia improvvisamente, dobbiamo scalare la velocity attuale
	# altrimenti il personaggio sembrerebbe fermarsi o schizzare via per un frame.
	if current_scale != last_time_scale:
		velocity *= (last_time_scale / current_scale)
		last_time_scale = current_scale

	# 3. APPLICAZIONE DEI POTENZIAMENTI
	# Modifichiamo le variabili che la State Machine andrà a leggere.
	# Le accelerazioni vanno al quadrato (warp^2), le velocità lineari (warp).
	max_speed = base_max_speed * warp
	acceleration = base_acceleration * (warp * warp)
	friction = base_friction * (warp * warp)
	gravity = base_gravity * (warp * warp)
	initial_jump_velocity = base_jump_velocity * warp
	LERP_VAL = base_lerp * warp

	
	# --- FINE LOGICA TEMPO REALE ---
	
	# 5. La TUA Logica Originale (eseguita con le variabili potenziate)
	if is_on_floor():
		velocity.y += grounded_gravity * warp # Corretto anche questo per coerenza
	else:
		var previous_y_velocity = velocity.y
		var new_y_velocity = velocity.y + (gravity * fall_multiplier * delta)
		var next_y_velocity = (previous_y_velocity + new_y_velocity) * 0.5
		velocity.y = next_y_velocity
		
	move_and_slide()

func setup_jump_variables() -> void:
	var time_to_apex = max_jump_time / 2
	gravity = (-2 * max_jump_height) / pow(time_to_apex, 2)
	initial_jump_velocity = (2 * max_jump_height) / time_to_apex
	
	# Aggiorno anche le base vars se questa funzione viene chiamata a runtime
	base_gravity = gravity
	base_jump_velocity = initial_jump_velocity

# HELPER 1
func get_input_direction_3d() -> Vector3:
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	return direction

# HELPER 2
func apply_horizontal_movement(direction: Vector3, speed: float):
	# Nota: qui 'speed' arriva dalla State Machine, che userà il nostro 'max_speed' potenziato.
	# get_physics_process_delta_time() restituirà il delta piccolo.
	# Potenziamento * Delta Piccolo = Movimento Reale.
	velocity.x = move_toward(velocity.x, speed * direction.x, acceleration * get_physics_process_delta_time())
	velocity.z = move_toward(velocity.z, speed * direction.z, acceleration * get_physics_process_delta_time())

# HELPER 3
func rotate_character(direction: Vector3):
	if direction.length_squared() > 0:
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(direction.x, direction.z), LERP_VAL * get_physics_process_delta_time())

# HELPER 4
func apply_deceleration():
	velocity.x = move_toward(velocity.x, 0, friction * get_physics_process_delta_time())
	velocity.z = move_toward(velocity.z, 0, friction * get_physics_process_delta_time())

func _on_change_scene_body_entered(body: Node3D) -> void:
	print("entrato")
	if body.is_in_group("player"):
		# Importante reset per evitare bug nella nuova scena
		Engine.time_scale = 1.0 
		get_tree().change_scene_to_file("res://scenes/music_island.tscn")
