@tool
extends ColorRect

var timer: float = 0.0

func _ready() -> void :
    timer = 0.0

func _physics_process(delta: float) -> void :
    timer += delta
    material.set_shader_parameter("timer", timer)
