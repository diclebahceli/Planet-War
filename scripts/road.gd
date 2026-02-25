class_name Road
extends Node2D

signal road_complete
signal road_cancel

@onready var path_2d: Path2D = $Path2D
@onready var line_2d: Line2D = $Line2D
@export var unit_manager : UnitManager
@export var click_tolerance : float = 15.0 # Mouse'un çizgiye ne kadar yakın olması gerektiğini belirler

var start_planet : Area2D = null
var current_points : Array[Vector2] = []
const MAX_POINTS : float = 200.0

var is_road :bool:
	get:
		return current_points.size() > 0
var is_road_active : bool = false



	
func start_road(planet: Planet) -> void: 
	if planet == null:
		return
	start_planet = planet
	Globals.state = Globals.DrawingState.DRAWING
	
	var start_pos : Vector2 = start_planet.global_position
	_add_point(start_pos)
	
	
	

	
func try_complete_road() -> void:

	var last_point : Vector2 = current_points[current_points.size() - 1]
	var end_planet : Area2D = Globals._get_planet_under_point(last_point)
	if end_planet == null or end_planet == start_planet:
		cancel_path()
	else:
		_complete_path(end_planet)



	
	
func cancel_path() -> void:
	for child : Node2D in path_2d.get_children():
		child.queue_free()
	line_2d.clear_points()
	path_2d.curve.clear_points()
	current_points.clear()
	
	start_planet = null
	Globals.state = Globals.DrawingState.IDLE
	unit_manager.stop_unit_spwaning()
	road_cancel.emit()
	
func _complete_path(end_planet : Area2D) -> void:
	var end_pos: Vector2 = end_planet.global_position
	_add_point(end_pos)
	
	Globals.state = Globals.DrawingState.IDLE
	unit_manager.start_unit_spawning()
	is_road_active = false
	road_complete.emit()
	
func _add_point(point : Vector2) -> void:
	current_points.append(point)
	line_2d.add_point(point)
	path_2d.curve.add_point(point)
	
	
	


func is_point_on_road(mouse_pos: Vector2) -> bool:
			
	# Eğri üzerindeki mouse'a en yakın noktayı bul
	var closest_point : Vector2 = path_2d.curve.get_closest_point(mouse_pos)
	
	# Mouse pozisyonu ile eğri üzerindeki nokta arasındaki mesafeyi ölç
	var distance : float = mouse_pos.distance_to(closest_point)
	
	# Eğer mesafe tolerans değerimizden küçükse (veya Line2D'nin kalınlığının yarısından), yolun üzerine tıklanmış demektir.
	# İstersen click_tolerance yerine (line_2d.width / 2.0 + 5.0) gibi dinamik bir değer de kullanabilirsin.
	if distance <= click_tolerance:
		return true
		
	return false
	
	
func draw_control() -> void:
	

	if current_points.size() <= 0:
		return

	if current_points.size() > MAX_POINTS:
		return
		
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	
	var planet_under_mouse : Area2D = Globals._get_planet_under_point(mouse_pos)
	if planet_under_mouse == start_planet:
		return
		
	var last_point : Vector2 = current_points[current_points.size() -1]
	if last_point.distance_to(mouse_pos) > 10.0:
		_add_point(mouse_pos)


	
func _process(_delta:float) -> void:
	draw_control()
	
