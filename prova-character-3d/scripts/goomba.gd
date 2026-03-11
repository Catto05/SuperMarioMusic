extends CharacterBody3D

@export var speed: float = 5.0  # Velocità in metri/secondo (in 3D i numeri sono più piccoli)
@export var detection_range: float = 10.0 # Metri
@export var wander_time: float = 2.0 
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Gravità standard di Godot
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

enum { WANDER, CHASE }
var state = WANDER

var wander_direction: Vector3 = Vector3.ZERO
var timer_wander: float = 0.0
@export var player : CharacterBody3D

func _ready():
	_pick_random_direction()

func _physics_process(delta):
	# 1. Applicare la gravità (fondamentale in 3D)
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Se non c'è il player, continua a vagare
	if not player:
		return

	# 2. Calcola distanza
	var dist = global_position.distance_to(player.global_position)

	# 3. Logica stati
	if dist < detection_range:
		state = CHASE
	else:
		state = WANDER
	
	match state:
		CHASE:
			_chase_state()
		WANDER:
			_wander_state(delta)
	
	if Vector2(velocity.x, velocity.z).length() > 0.1:	
		var look_target = global_position + velocity
		look_target.y = global_position.y
		look_at(look_target, Vector3.UP)

	move_and_slide()

func _chase_state():
	var target_pos = player.global_position
	target_pos.y = global_position.y
	var direction = (target_pos - global_position).normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

func _wander_state(delta):
	timer_wander -= delta
	if timer_wander <= 0:
		_pick_random_direction()
		timer_wander = wander_time
	
	# Muoviti più lentamente quando vaga
	velocity.x = wander_direction.x * (speed * 0.5)
	velocity.z = wander_direction.z * (speed * 0.5)

func _pick_random_direction():
	wander_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
