extends PathFollow2D

const SPEED: float = 900.0


func _process(delta: float) -> void:
	
	progress += delta * SPEED 
		
