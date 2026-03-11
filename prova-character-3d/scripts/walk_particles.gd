extends GPUParticles3D
@export var offset : float
func _ready() -> void:
	emitting = false
	
func _process(delta: float) -> void:
	var player = get_parent_node_3d()
	if player.is_walking:
		await get_tree().create_timer(offset).timeout
		emitting = true
	else:
		emitting = false
