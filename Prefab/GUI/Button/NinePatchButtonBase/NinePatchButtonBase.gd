@tool
class_name NinePatchButtonBase extends MarginContainer

@onready var ninePatchTexture: NinePatchRect = %NinePatchTexture
@onready var labelText: Label = %LabelText

@export var disable: bool = false:
    set(_disable):
        disable = _disable
        if disable:
            ninePatchTexture.texture = normalTexture

@export_multiline var text: String:
    set(str):
        text = str
        if labelText:
            labelText.text = str

@export var normalTexture: Texture2D:
    set(texture):
        normalTexture = texture
        if ninePatchTexture:
            ninePatchTexture.texture = texture

@export var pressedTexture: Texture2D:
    set(texture):
        pressedTexture = texture

@export var hoverTexture: Texture2D:
    set(texture):
        hoverTexture = texture

@export var downSfx: String = "ButtonClickPress"
@export var upSfx: String = "ButtonClickRelease"

signal pressed()
signal mouseEntered()
signal mouseExited()

func _ready() -> void :
    labelText.text = text
    ninePatchTexture.texture = normalTexture

func _Pressed() -> void :
    if disable:
        return
    ninePatchTexture.texture = pressedTexture
    pressed.emit()

func _MouseEntered() -> void :
    if disable:
        return
    ninePatchTexture.texture = hoverTexture
    mouseEntered.emit()

func _MouseExited() -> void :
    if disable:
        return
    ninePatchTexture.texture = normalTexture
    mouseExited.emit()

func ButtonDown() -> void :
    if disable:
        return
    if downSfx != "":
        AudioManager.AudioPlay(downSfx, AudioManagerEnum.TYPE.SFX)

func ButtonUp() -> void :
    if disable:
        return
    if upSfx != "":
        AudioManager.AudioPlay(upSfx, AudioManagerEnum.TYPE.SFX)
