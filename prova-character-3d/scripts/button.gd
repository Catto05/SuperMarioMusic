# button.gd
extends SimpleInteractable

@onready var animation_player: AnimationPlayer = $"Sketchfab_model/StaticBody3D/Collada visual scene group/pSphere1/AnimationPlayer"
@onready var planes_container: Node3D = $"../flipping_planes_tutorial"


func interact() -> void:
	animation_player.play("button_pressed")
	var lista_oggetti = planes_container.get_children()
	for oggetto in lista_oggetti:
		if oggetto is flipping_plane_class:
			oggetto.button_is_pressed()
