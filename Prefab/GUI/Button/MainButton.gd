@tool
class_name MainButton extends TextureButton

@onready var label = %TextLabel

@export var text: String = "Test"

func _ready() -> void :
    label.text = text

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    label.text = text
    label.size = size - Vector2(20, 0)
    label.global_position = global_position + Vector2(10, 0)

func ButtonPressed() -> void :
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)
