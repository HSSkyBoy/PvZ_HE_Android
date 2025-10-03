@tool
class_name SpriteBrightButton extends TextureRect

@onready var button: Button = %Button

@export var autoSize: bool = false
@export var disabled: bool = false

func _ready():
    material = material.duplicate()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if autoSize:
        button.position = Vector2.ZERO
        button.size = size

signal pressed()
signal mouseEntered()
signal mouseExited()

func _Pressed():
    if disabled:
        return
    pressed.emit()
    AudioManager.AudioPlay("ButtonPress", AudioManagerEnum.TYPE.SFX)

func _MouseEntered():
    mouseEntered.emit()
    if disabled:
        return
    material.set("shader_parameter/brightStrength", 0.3)


func _MouseExited():
    mouseExited.emit()
    if disabled:
        return
    material.set("shader_parameter/brightStrength", 0)
