class_name Player
extends Node2D

var mouse_pos: Vector2
@export var road_manager : RoadManager


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
	if road_manager.active_road == null:
		return
	var planet : Area2D = Globals._get_planet_under_point(mouse_pos)
	road_manager.active_road.start_road(planet)



func _on_mouse_released() -> void:
	if Globals.state != Globals.DrawingState.DRAWING:
		road_manager.check_and_cancel_roads(mouse_pos)
		
	if Globals.state == Globals.DrawingState.DRAWING:
			road_manager.active_road.try_complete_road()
		
		
