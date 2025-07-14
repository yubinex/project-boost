extends RigidBody3D


## The vertical force applied to the object when moving upwards,
## controlling the strength of the thrust.
@export_range(750.0, 3000.0, 1.0) var thrust: float = 1000.0
## The rotational force applied to the object,
## controlling how quickly it rotates or turns.
@export var torque_thrust: float = 100.0

var is_transitioning: bool = false

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio

@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var booster_particles_left: GPUParticles3D = $Body/LeftArm/BoosterParticlesLeft
@onready var booster_particles_right: GPUParticles3D = $Body/RightArm/BoosterParticlesRight
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thrust)
		booster_particles.emitting = true
		if !rocket_audio.playing:
			rocket_audio.play()
	else:
		booster_particles.emitting = false
		rocket_audio.stop()

	if Input.is_action_pressed("left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		booster_particles_right.emitting = true
	else:
		booster_particles_right.emitting = false

	if Input.is_action_pressed("right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
		booster_particles_left.emitting = true
	else:
		booster_particles_left.emitting = false


func _on_body_entered(body: Node) -> void:
	if is_transitioning == false:
		if "Goal" in body.get_groups():
			call_deferred("complete_level", body.file_path)

		if "Hazard" in body.get_groups():
			call_deferred("crash_sequence")


func complete_level(next_level_file: String) -> void:
	print("Level Complete!")
	success_particles.emitting = true
	success_audio.play()
	set_process(false)
	is_transitioning = true
	var tween: Tween = create_tween()
	tween.tween_interval(1.5)
	tween.tween_callback(get_tree().change_scene_to_file.bind(next_level_file))


func crash_sequence() -> void:
	print("KABOOM!")
	explosion_particles.emitting = true
	explosion_audio.play()
	set_process(false)
	is_transitioning = true
	var tween: Tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)
