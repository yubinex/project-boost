extends RigidBody3D

## The vertical force applied to the object when moving upwards,
## controlling the strength of the thrust.
@export_range(750.0, 3000.0) var thrust: float = 1000.0
## The rotational force applied to the object,
## controlling how quickly it rotates or turns.
@export var torque_thrust: float = 100.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)

	if Input.is_action_pressed("left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))

	if Input.is_action_pressed("right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))


func _on_body_entered(body: Node) -> void:
	if "Goal" in body.get_groups():
		print("You win!")

	if "Hazard" in body.get_groups():
		print("You crashed!")
