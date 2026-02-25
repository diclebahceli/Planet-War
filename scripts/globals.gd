extends Node2D

var state : DrawingState = DrawingState.IDLE


enum DrawingState{
	IDLE,
	DRAWING
}


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
