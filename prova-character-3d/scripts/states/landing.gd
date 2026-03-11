extends state
class_name landing

func enter():
	print("entrato in landing")
	character.can_hit_goomba = true
	if !character.can_hit_goomba:
		print("cannot hit")
	animation_player.speed_scale = anim_speed * character.warp
	character.fall_multiplier = fall_multiplier
	animation_player.play("Falling To Landing/mixamo_com")
	
func physics_update(_delta:float):
	var direction = character.get_input_direction_3d()
	character.apply_horizontal_movement(direction, character.max_speed)
	character.rotate_character(direction)
	if Input.is_action_just_pressed("jump") and !character.has_double_jumped:
		print("jump")
		transitioned.emit(self, "double_jump")
		
	if character.is_on_floor() :#and !animation_player.is_playing()
		var input_dir = character.get_input_direction_3d()
		character.has_double_jumped = false
		if input_dir:
			transitioned.emit(self, "walk")
		else:
			transitioned.emit(self, "idle")
		return # Atterrato, esci
		
func exit():
	character.can_hit_goomba = false
