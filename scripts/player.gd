extends KinematicBody

export var speed = 7
export var accel = 10
export var gravity = 50
export var jump = 0
export var sensitivity = 0.5
export var max_angle = 90
export var min_angle = -80

onready var head = $Camera
onready var walk_sound = $walk_sound

var look_rot = Vector3.ZERO
var move_dir = Vector3.ZERO
var velocity = Vector3.ZERO

func _ready():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func restart():
	get_tree().reload_current_scene()

func control(delta):
	head.rotation_degrees.x = look_rot.x
	rotation_degrees.y = look_rot.y
	if not is_on_floor():
		velocity.y -= gravity * delta
	if Input.is_action_just_pressed("space") and is_on_floor():
		velocity.y = jump
	move_dir = Vector3(
		Input.get_axis("a", "d"),
		0,
		Input.get_axis("w", "s")
	).normalized().rotated(Vector3.UP, rotation.y)
	velocity.x = lerp(velocity.x, move_dir.x * speed, accel * delta)
	velocity.z = lerp(velocity.z, move_dir.z * speed, accel * delta)
	velocity = move_and_slide(velocity, Vector3.UP)

func walk_sound():
	if walk_sound.get_stream_paused():
		if Input.is_action_pressed('w') or Input.is_action_pressed('a') or Input.is_action_pressed('s') or Input.is_action_pressed('d'):
			walk_sound.set_stream_paused(false)
			
	if !walk_sound.get_stream_paused() and (Input.is_action_just_released('w') or Input.is_action_just_released('a') or Input.is_action_just_released('s') or Input.is_action_just_released('d')):
		walk_sound.set_stream_paused(true)


func _physics_process(delta):
	control(delta)
	walk_sound()
	
	if Input.is_action_just_pressed("click"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	if self.global_translation.y < -20:
		restart()

func _input(event):
	if event is InputEventMouseMotion:
		look_rot.y -= (event.relative.x * sensitivity)
		look_rot.x -= (event.relative.y * sensitivity)
		look_rot.x = clamp(look_rot.x, min_angle, max_angle)

