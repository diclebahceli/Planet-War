class_name Road
extends Node2D

signal road_complete

@onready var path_2d: Path2D = $Path2D
@onready var line_2d: Line2D = $Line2D
@export var unit_manager : UnitManager

var start_planet : Area2D = null
var current_points : Array[Vector2] = []
const MAX_POINTS : float = 200.0
var is_road :bool:
	get:
		return current_points.size() > 0
var is_road_active : bool = false
enum PathState{
	IDLE,
	DRAWING
}

var state : PathState = PathState.IDLE

func _ready() -> void:
	path_2d.curve = Curve2D.new()

func _unhandled_input(event: InputEvent) -> void:
	if is_road_active == false:
		return
	if event is InputEventMouseButton:
		var mouse_event : InputEventMouseButton = event
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			var mouse_pos : Vector2 = get_global_mouse_position()
			if mouse_event.pressed:
				_on_mouse_pressed(mouse_pos)
			else: 
				_on_mouse_released()
				
				
func _on_mouse_pressed(mouse_pos: Vector2) -> void:
	
	var planet : Area2D = _get_planet_under_point(mouse_pos)
	if planet == null:
		return
	_cancel_path()
	start_planet = planet
	state = PathState.DRAWING
	
	var start_pos : Vector2 = start_planet.global_position
	_add_point(start_pos)
	
func _on_mouse_released() -> void:
	if state != PathState.DRAWING:
		return
	var last_point : Vector2 = current_points[current_points.size() - 1]
	var end_planet : Area2D = _get_planet_under_point(last_point)
	if end_planet == null or end_planet == start_planet:
		_cancel_path()
	else:
		_complete_path(end_planet)

	
	
func _cancel_path() -> void:
	for child : Node2D in path_2d.get_children():
		child.queue_free()
	line_2d.clear_points()
	path_2d.curve.clear_points()
	current_points.clear()
	
	start_planet = null
	state = PathState.IDLE
	unit_manager.stop_unit_spwaning()
	
	
func _complete_path(end_planet : Area2D) -> void:
	var end_pos: Vector2 = end_planet.global_position
	_add_point(end_pos)
	
	state = PathState.IDLE
	unit_manager.start_unit_spawning()
	is_road_active = false
	road_complete.emit()
	
func _add_point(point : Vector2) -> void:
	current_points.append(point)
	line_2d.add_point(point)
	path_2d.curve.add_point(point)
	
	
	
func _get_planet_under_point(mouse_pos : Vector2) -> Area2D:
	var space_state : PhysicsDirectSpaceState2D	 = get_world_2d().direct_space_state
	
	var query : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true
	
	var results : Array[Dictionary] = space_state.intersect_point(query)
	for result : Dictionary in results:
		var collider: Node2D = result["collider"]
		if collider is Planet:
			return collider
	return null
	
func _process(_delta:float) -> void:
	
	if current_points.size() > MAX_POINTS:
		return
	
	
	if state != PathState.DRAWING:
		return
		
	var mouse_pos : Vector2 = get_global_mouse_position()
	
	if current_points.is_empty():
		return
		
	var planet_under_mouse : Area2D = _get_planet_under_point(mouse_pos)
	if planet_under_mouse == start_planet:
		return
		
	var last_point : Vector2 = current_points[current_points.size() -1]
	if last_point.distance_to(mouse_pos) > 10.0:
		_add_point(mouse_pos)
