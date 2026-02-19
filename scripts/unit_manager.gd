class_name GameManager
extends Node2D

@export var unit_scene : PackedScene
@onready var timer: Timer = $Timer
var parent_path : Path = null


func _ready() -> void:
	var path_drawer : Path = get_parent().get_node("Path")
	path_drawer.path_completed.connect(_on_path_completed)
	path_drawer.path_cancelled.connect(_on_path_cancelled)
	timer.timeout.connect(_on_spawn_unit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _on_path_completed(path: Path2D) -> void:
	parent_path = path.get_parent()
	_on_spawn_unit()
	timer.start()

func _on_spawn_unit() -> void:
	print("spawning")
	var unit: Unit = unit_scene.instantiate()
	unit.origin_planet = parent_path.start_planet
	parent_path.path_2d.add_child(unit)
	
	
func _on_path_cancelled() -> void:
	timer.stop()
