extends state
class_name idle

func enter():
	if !character.warp: return
	animation_player.speed_scale = anim_speed * character.warp
	animation_player.play("Idle/mixamo_com")
	character.apply_deceleration()
	
func physics_update(_delta:float):
	# --- Controlla le transizioni in ordine di priorità ---
	
	# 1. Stai cadendo da un dirupo? (Priorità massima)
	if not character.is_on_floor():
		# Non applichiamo JUMP_VELOCITY qui. Il personaggio sta solo cadendo.
		transitioned.emit(self, "jump_down") # <- Va allo stato "in aria"
		return

	# 2. Hai premuto Salta?
	if Input.is_action_just_pressed("jump"):
		transitioned.emit(self, "jump") # Questo è il salto intenzionale
		return
		
	# 3. Ti stai muovendo?
	var direction = character.get_input_direction_3d()
	if direction:
		transitioned.emit(self, "walk")
		return
