extends CharacterBody2D


const SPEED : float = 9000.0
@export var start_point : Marker2D
@export var end_point : Marker2D



func _physics_process(delta: float) -> void:

	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction : Vector2 = (end_point.global_position - start_point.global_position).normalized()
	
	if direction:
		velocity = direction * SPEED * delta

	move_and_slide()
