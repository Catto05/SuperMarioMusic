extends Node3D
@onready var flipping_plane: Node3D = $FlippingPlane
@onready var button: Node3D = $button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button.button_activated.connect(flipping_plane.button_is_pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
