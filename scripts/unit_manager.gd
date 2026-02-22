class_name UnitManager
extends Node2D

@export var unit_scene : PackedScene
@export var road : Road
@onready var timer: Timer = $Timer



func _ready() -> void:
	timer.timeout.connect(_on_spawn_unit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func start_unit_spawning() -> void:
	_on_spawn_unit()
	timer.start()

func _on_spawn_unit() -> void:
	var unit: Unit = unit_scene.instantiate()
	unit.origin_planet = road.start_planet
	road.path_2d.add_child(unit)
	
	
func stop_unit_spwaning() -> void:
	timer.stop()
