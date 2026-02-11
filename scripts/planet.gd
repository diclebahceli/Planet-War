extends Area2D
class_name Planet

@export var planet_id: int = 0

func _ready() -> void:
	print("Planet ready:", self)

func get_connection_position() -> Vector2:
	var marker: Marker2D = $ConnectionPoint
	return marker.global_position
