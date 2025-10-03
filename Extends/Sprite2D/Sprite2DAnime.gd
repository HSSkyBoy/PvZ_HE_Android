@tool
class_name SpriteAnime extends Sprite2D

@export var isPlaying: bool = true
@export var fps: float = 24.0
var frameNum: int = 0

var timer: float = 0.0

func _ready() -> void :
    frameNum = hframes * vframes

func _process(delta: float) -> void :
    if !isPlaying:
        return
    if Engine.is_editor_hint():
        frameNum = hframes * vframes
    if timer < 1.0 / fps:
        timer += delta
    else:
        timer = 0
        frame = (frame + 1) %frameNum
