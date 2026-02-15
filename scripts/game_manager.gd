extends Node2D

@export var unit_scene : PackedScene

func _ready() -> void:
	var path_drawer : Path = get_parent().get_node("Path")
	path_drawer.path_completed.connect(_on_path_completed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_path_completed(path: Path2D) -> void:
	var unit: PathFollow2D = unit_scene.instantiate()
	path.add_child(unit)
	unit.progress = 0
	
