extends state
class_name jump
func enter():
	animation_player.speed_scale = anim_speed * character.warp
	animation_player.play("Jumping Up/mixamo_com") # Suona l'animazione completa
	character.fall_multiplier = fall_multiplier
	character.velocity.y = character.initial_jump_velocity * .5
	
func physics_update(_delta:float):
	# --- 1. Logica di Stato (Controllo Aereo) ---
	var direction = character.get_input_direction_3d()
	character.apply_horizontal_movement(direction, character.max_speed)
	character.rotate_character(direction)
	if Input.is_action_just_released("jump"):
		print("maiov")
		transitioned.emit(self, "jump_down")
	if Input.is_action_just_pressed("jump"):
		print("jump")
		transitioned.emit(self, "double_jump")
	if character.velocity.y <= 0:
		transitioned.emit(self, "jump_down")
	if character.is_on_floor(): #and !animation_player.is_playing():
		var input_dir = character.get_input_direction_3d()
		if input_dir:
			transitioned.emit(self, "walk")
		else:
			transitioned.emit(self, "idle")
		return 
