extends state
class_name jump_down

func enter():
	print("jumping down")
	animation_player.speed_scale = anim_speed * character.warp
	character.fall_multiplier = fall_multiplier
	animation_player.play("Falling Idle/mixamo_com")
	character.can_hit_goomba = true
	
func physics_update(_delta:float):
	var direction = character.get_input_direction_3d()
	character.apply_horizontal_movement(direction, character.max_speed)
	character.rotate_character(direction)
	if Input.is_action_just_pressed("jump") and !character.has_double_jumped:
		transitioned.emit(self, "double_jump")
	if ray_cast.is_colliding():
		transitioned.emit(self, "landing")
	if character.is_on_floor():
		var input_dir = character.get_input_direction_3d()
		character.has_double_jumped = false
		if input_dir:
			transitioned.emit(self, "walk")
		else:
			transitioned.emit(self, "idle")
		return
		
func exit():
	character.can_hit_goomba = false
