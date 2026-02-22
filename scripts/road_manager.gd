class_name RoadManager
extends Node2D



const ROAD: PackedScene = preload("uid://bddso030ibqfv")
@export var road_limit: int
var road_list : Array[Road] = []


func _ready() -> void:
	for i:int in range(0,road_limit):
		var current_road: Road = ROAD.instantiate()
		road_list.append(current_road)
		add_child(current_road)
		current_road.road_complete.connect(set_road_active)
	set_road_active()
	
	
func set_road_active() -> void:
	for road:Road in road_list:
		if not road.is_road:
			road.is_road_active = true
			return
		
