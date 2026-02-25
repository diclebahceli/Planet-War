class_name RoadManager
extends Node2D



const ROAD: PackedScene = preload("uid://bddso030ibqfv")
@export var road_limit: int
var road_list : Array[Road] = []
var active_road: Road


func _ready() -> void:
	for i:int in range(0,road_limit):
		var current_road: Road = ROAD.instantiate()
		road_list.append(current_road)
		add_child(current_road)
		current_road.road_complete.connect(set_road_active)
	set_road_active()
	
func check_active_roads() -> bool:
	var result : bool = false
	for road:Road in road_list:
		if  road.is_road_active:
			result = true
			break
	return result
	 
func set_road_active() -> void:
	var is_road_exist : bool = check_active_roads()
	if is_road_exist:
		return
	for road:Road in road_list:
		if not road.is_road:
			road.is_road_active = true
			active_road = road
			return
		
func check_and_cancel_roads(mouse_pos: Vector2) -> void:
	for road:Road in road_list:
		if road.is_road and road.is_road_active == false:
			var is_mouse_on_road: bool = road.is_point_on_road(mouse_pos)
			if is_mouse_on_road: 
				road.cancel_path()	
