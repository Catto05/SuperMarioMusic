extends Marker3D

#var parent: Node3D = null
## Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#top_level = true
	#parent = get_parent()
#
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _physics_process(delta: float) -> void:
	#if !parent: return
	#lerp(global_position, parent.global_position, delta)
