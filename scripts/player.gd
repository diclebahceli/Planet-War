extends Node2D

var mouse_pos: Vector2
var road_manager : RoadManager


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mouse_event : InputEventMouseButton = event
		if mouse_event.button_index == MOUSE_BUTTON_LEFT:
			mouse_pos = get_global_mouse_position()
			if mouse_event.pressed:
				_on_mouse_pressed()
			else: 
				_on_mouse_released()



func _on_mouse_pressed() -> void:
	var planet : Area2D = _get_planet_under_point(mouse_pos)
	road_manager.active_road.start_road(planet)



func _on_mouse_released() -> void:
	if Globals.state != Globals.DrawingState.DRAWING:
		road_manager.check_and_cancel_roads(mouse_pos)
		
	if Globals.state == Globals.DrawingState.DRAWING and is_road_active:
		print("COMPLETING")
		try_complete_road()
		
		

func _get_planet_under_point(selected_mouse_pos : Vector2) -> Area2D:
	var space_state : PhysicsDirectSpaceState2D	 = get_world_2d().direct_space_state
	
	var query : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	query.position = selected_mouse_pos
	query.collide_with_areas = true
	
	var results : Array[Dictionary] = space_state.intersect_point(query)
	for result : Dictionary in results:
		var collider: Node2D = result["collider"]
		if collider is Planet:
			return collider
	return null
