extends StaticBody3D
@export var fungo: PackedScene
@onready var spawn_point: Marker3D = $"../spawn_point"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var position = global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_area_3d_body_entered(body: Node3D) -> void:
	print("toccato")
	if body.is_in_group("player"):
		var new_instance = fungo.instantiate()
		get_tree().current_scene.add_child(new_instance)
		new_instance.global_position = spawn_point.global_position
		queue_free()
