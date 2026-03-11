extends Node3D
class_name flipping_plane_class
@onready var flip: BoneAttachment3D = $Armature/Skeleton3D/flip
@onready var animation_player: AnimationPlayer = $AnimationPlayer

const song = preload("uid://bqbpe21h0u0hr")
var can_flip:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	can_flip = false
	Conductor.set_song(song,130.0,4,0)
	Conductor.measure.connect(_on_beat)
	
func _on_beat(beat_number):
	if can_flip:
		animation_player.play("ArmatureAction")
		print("beat")

func button_is_pressed():
	can_flip = true
	Conductor.play()
