@tool
class_name GeneralProgressFlag extends Control

@onready var pos: Node2D = %Pos

@export var reach: bool = false

func _physics_process(delta: float) -> void :
    if reach:
        pos.position.y = lerp(pos.position.y, 45.0, 1.0 * delta)
    else:
        pos.position.y = lerp(pos.position.y, 55.0, 1.0 * delta)
