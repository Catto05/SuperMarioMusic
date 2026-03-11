extends Area3D
@export var goomba : CharacterBody3D
@onready var mario: CharacterBody3D = $"../../mario"
@onready var collision_shape_goomba: CollisionShape3D = $"../CollisionShape3D"
@onready var collision_shape_area: CollisionShape3D = $CollisionShape3D
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player") and mario.can_hit_goomba:
		var children = body.get_children()
		for child in children:
			if child.name == "state_machine":
				child.on_child_transitioned(child.current_state, "jump")
		collision_shape_area.set_deferred("disabled", true)
		var tween = create_tween()
		tween.tween_property(goomba, "scale:y", 0.05, 0.7).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		goomba.speed = 0
		animation_player.stop()
		await get_tree().create_timer(4).timeout
		goomba.queue_free()
		
		
		
