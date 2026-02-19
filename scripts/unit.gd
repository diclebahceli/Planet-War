class_name Unit
extends PathFollow2D

const SPEED: float = 900.0
@onready var area_2d: Area2D = $Area2D
var origin_planet: Area2D = null

func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)

func _process(delta: float) -> void:
	progress += delta * SPEED 
		
func _on_area_entered(planet: Area2D) -> void:
	if planet == origin_planet:
		return
	if planet is Planet:
		queue_free()
