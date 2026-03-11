extends state
class_name double_jump
func enter():
	character.has_double_jumped = true
	print("double jump")
	character.velocity.y = character.initial_jump_velocity
	animation_player.speed_scale = anim_speed * character.warp
	animation_player.play("Running Forward Flip/mixamo_com")
func physics_update(_delta:float):
	# --- 1. Logica di Stato (Controllo Aereo) ---
	var direction = character.get_input_direction_3d()
	character.apply_horizontal_movement(direction, character.max_speed)
	character.rotate_character(direction)
	
	if character.velocity.y <= 0:
		transitioned.emit(self, "jump_down")
	if ray_cast.is_colliding() and !animation_player.is_playing() :
		transitioned.emit(self, "landing")
	if character.is_on_floor() and !animation_player.is_playing():
		
		var input_dir = character.get_input_direction_3d()
		if input_dir:
			transitioned.emit(self, "walk")
		else:
			transitioned.emit(self, "idle")
		return 
