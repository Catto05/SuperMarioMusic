extends SimpleInteractable
@onready var arrow: Node3D = $"../arrow"
@onready var arrow_2: Node3D = $"../arrow2"
@onready var to_be_removed: CollisionShape3D = $"../world_borders/to_be_removed"
@export var mario: CharacterBody3D
func on_enter() -> void:
	arrow.hide()
	arrow_2.show()
	if is_instance_valid(to_be_removed):
		to_be_removed.queue_free()
	GameManager.last_position = mario.global_position
