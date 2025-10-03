class_name CameraMovingControl extends Node

var WINDOW_WIDTH: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var WINDOW_HEIGHT: int = ProjectSettings.get_setting("display/window/size/viewport_height")

@export var alive: bool = true

@export var camera: Camera2D
@export var cameraZoomMin: Vector2 = Vector2(1.5, 1.5)
@export var cameraZoomMax: Vector2 = Vector2(1.0, 1.0)
@export var edgeMarkUL: Marker2D
@export var edgeMarkDR: Marker2D

var mousePress: bool = false
var mouseSavePos: Vector2 = Vector2.ZERO


func _ready() -> void :
	pass

@warning_ignore("unused_parameter")
func _input(event: InputEvent) -> void :
	if !alive:
		return
	if Input.is_action_just_released("RollUp"):
		camera.zoom += Vector2.ONE * 0.05

	if Input.is_action_just_released("RollDown"):
		camera.zoom -= Vector2.ONE * 0.05

	if Input.is_action_just_pressed("Press"):
		mousePress = true
		mouseSavePos = get_viewport().get_mouse_position()

	if Input.is_action_just_released("Press"):
		mousePress = false

	if mousePress:
		camera.global_position = camera.global_position + (mouseSavePos - get_viewport().get_mouse_position())
		mouseSavePos = get_viewport().get_mouse_position()

	camera.zoom.x = clamp(camera.zoom.x, cameraZoomMax.x, cameraZoomMin.x)
	camera.zoom.y = clamp(camera.zoom.y, cameraZoomMax.y, cameraZoomMin.y)

	camera.global_position.x = clamp(camera.global_position.x, edgeMarkUL.global_position.x, edgeMarkDR.global_position.x - WINDOW_WIDTH / camera.zoom.x)
	camera.global_position.y = clamp(camera.global_position.y, edgeMarkUL.global_position.y, edgeMarkDR.global_position.y - WINDOW_HEIGHT / camera.zoom.y)
