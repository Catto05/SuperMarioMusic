extends state
class_name walk

func enter():
	var speed_ratio = 1.0 # Valore di default
	animation_player.speed_scale = anim_speed * speed_ratio * character.warp
	character.is_walking = true
	animation_player.play("Running/mixamo_com")

func physics_update(_delta:float):
	# --- Controlla le transizioni in ordine di priorità ---
	var h_velocity = Vector3(character.velocity.x, 0, character.velocity.z)
	var current_speed = h_velocity.length()
	var speed_ratio = 1.0 # Valore di default
	speed_ratio = clamp(current_speed / character.max_speed, 0.0, 1.0)
	animation_player.speed_scale = anim_speed * speed_ratio * character.warp
	
	if not character.is_on_floor():
		transitioned.emit(self, "jump_down")
		if ray_cast.is_colliding():
			transitioned.emit(self, "landing")
		return

	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "jump") # Questo è il salto intenzionale
		return
		
	# --- Esegui la logica di questo stato ---
	var direction = character.get_input_direction_3d()
	
	if direction:
		character.apply_horizontal_movement(direction, character.max_speed)
		character.rotate_character(direction)
	else:
		character.apply_deceleration()
		transitioned.emit(self, "idle")

func exit():
	character.is_walking = false
