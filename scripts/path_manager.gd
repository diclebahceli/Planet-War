class_name PathManager
extends Node2D

const PATH: PackedScene = preload("uid://bddso030ibqfv")
@export var path_limit: int
var path_list : Array[Path] = []


func _ready() -> void:
	for i:int in range(0,path_limit):
		var current_path: Path = PATH.instantiate()
		path_list.append(current_path)
	
