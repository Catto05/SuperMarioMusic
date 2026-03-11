extends Node
class_name state
signal transitioned
var has_double_jumped: bool

@export var character: CharacterBody3D
@export var anim_speed: float = 1
@export var fall_multiplier:float = 1
# Ottieni l'AnimationPlayer dal 'character' che ti viene passato
@onready var animation_player: AnimationPlayer = character.get_node("T-Pose/AnimationPlayer")
@onready var ray_cast: RayCast3D = character.get_node("RayCast3D")

func enter():
	pass
	
func exit():
	pass
	
func update(_delta:float):
	pass
	
func physics_update(_delta:float):
	pass
