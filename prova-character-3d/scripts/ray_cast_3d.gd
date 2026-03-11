extends ShapeCast3D
@export var character : CharacterBody3D
@onready var blob_shadow: Decal = $blob_shadow
var ratio:float = 0
#var global_position_shape = character.global_position + Vector3(0,0.5,0)
#var ratio = global_position / target_position
func _ready():
	global_position.y += 0.5
func _process(delta: float) -> void:
	if is_colliding():
		var point := get_collision_point(0)
		var distance := point - character.global_position + Vector3(0,0.5,0)
		ratio = target_position.length() / distance.length()
		
		blob_shadow.show()
		ratio = _map_range(ratio, 0, target_position.length(), 0.7, 1)
		ratio = clamp(ratio,0,1)
		blob_shadow.modulate.a = ratio
		blob_shadow.global_position.y = point.y
	else:
		blob_shadow.hide()


func _map_range(value: float, low1:float, high1:float, low2:float, high2:float) ->float:
	return low2 + (value-low1) * (high2 - low2) / (high1 - low1)
