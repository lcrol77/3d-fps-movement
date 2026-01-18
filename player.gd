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

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var rig: Node3D = $Rig

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _input(input_event: InputEvent) -> void:
	if input_event is InputEventMouseMotion:
		_yaw -= input_event.screen_relative.x * MOUSE_SENSITIVITY * 0.001
		rig.rotation = Vector3(0,_yaw,0)
