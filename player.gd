extends Node3D


var new_var: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var my_number: int = 10
	print(my_number)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		print("spacebar was pressed")
		new_var += 10
		print(new_var)
