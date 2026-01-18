class_name Player
extends CharacterBody3D

const MOUSE_SENSITIVITY = 2.5
const CAMERA_SMOOTH_SPEED = 10.0
const MOVE_SPEED = 3.0
const FRICTION = 10.0
const JUMP_VELOCITY = 8.0
const BULLET_SPEED = 9.0

var _yaw: float = 0 
var _pitch: float = 0 

var _dir := Vector3(sin(_yaw), 0, cos(_yaw))

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var rig: Node3D = $Rig

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Rig/MeshBody.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_SHADOWS_ONLY
	print(get_tree().physics_interpolation)


func _input(input_event: InputEvent) -> void:
	if input_event is InputEventMouseMotion:
		_yaw -= input_event.screen_relative.x * MOUSE_SENSITIVITY * 0.001
		_pitch += input_event.screen_relative.y * MOUSE_SENSITIVITY * 0.002
		_pitch = clamp(_pitch, -PI, PI)

func _update_camera() -> void:
	# Keep the player direction up-to-date based on the yaw.
	_dir.x = sin(_yaw)
	_dir.z = cos(_yaw)

	# Rotate the head (and FPS camera and firing origin) with the
	# pitch from the mouse.
	rig.rotation = Vector3(0,_yaw,0)

	$Rig/Head.rotation = Vector3(_pitch * -0.5, 0, 0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"fire"):
		pass
		
	if Input.is_action_just_pressed(&"reset_position") or position.length() > 10.0:
		pass

	if Input.is_action_just_pressed(&"jump") and is_on_floor():
		pass
	_update_camera()


func _physics_process(delta: float) -> void:

	var move := Vector3()
	var input: Vector2 = Input.get_vector(&"move_left",&"move_right",&"move_forward",&"move_backward") * MOVE_SPEED
	move.x = input.x
	move.z = input.y
	move.y -= gravity * delta
	move = move.rotated(Vector3(0, 1, 0), _yaw)
	velocity += move
	move_and_slide()
	
	var friction_delta := exp(-FRICTION * delta)
	velocity = Vector3(velocity.x * friction_delta, velocity.y, velocity.z * friction_delta)
