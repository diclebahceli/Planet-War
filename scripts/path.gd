extends Node2D

@onready var path_2d: Path2D = $Path2D
@onready var line_2d: Line2D = $Line2D

var start_planet: Area2D = null
var current_points: Array[Vector2] = []

enum PathState {
	IDLE,
	DRAWING
}

var state: PathState = PathState.IDLE


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event: InputEventMouseButton = event
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			if mouse_event.pressed:
				_on_mouse_pressed(mouse_event.position)
			else:
				_on_mouse_released(mouse_event.position)


func _process(_delta: float) -> void:
	if state != PathState.DRAWING:
		return

	var mouse_pos: Vector2 = get_global_mouse_position()

	if current_points.is_empty():
		return

	var last_point: Vector2 = current_points[current_points.size() - 1]
	if last_point.distance_to(mouse_pos) > 10.0:
		_add_point(mouse_pos)


func _on_mouse_pressed(mouse_pos: Vector2) -> void:
	var planet: Area2D = _get_planet_under_mouse(mouse_pos)
	if planet == null:
		return

	start_planet = planet
	state = PathState.DRAWING

	current_points.clear()
	line_2d.clear_points()
	path_2d.curve.clear_points()

	var start_pos: Vector2 = start_planet.global_position
	_add_point(start_pos)


func _on_mouse_released(mouse_pos: Vector2) -> void:
	if state != PathState.DRAWING:
		return

	var end_planet: Area2D = _get_planet_under_mouse(mouse_pos)

	if end_planet == null or end_planet == start_planet:
		_cancel_path()
	else:
		_complete_path(end_planet)


func _cancel_path() -> void:
	line_2d.clear_points()
	path_2d.curve.clear_points()
	current_points.clear()

	start_planet = null
	state = PathState.IDLE


func _complete_path(end_planet: Area2D) -> void:
	var end_pos: Vector2 = end_planet.global_position
	_add_point(end_pos)

	start_planet = null
	state = PathState.IDLE


func _add_point(point: Vector2) -> void:
	current_points.append(point)
	line_2d.add_point(point)
	path_2d.curve.add_point(point)


func _get_planet_under_mouse(mouse_pos: Vector2) -> Area2D:
	var space_state: PhysicsDirectSpaceState2D = get_world_2d().direct_space_state

	var query: PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collide_with_areas = true

	var results: Array[Dictionary] = space_state.intersect_point(query)

	for result: Dictionary in results:
		var collider: Node2D = result["collider"]
		if collider is Area2D and collider.is_in_group("planet"):
			return collider

	return null
