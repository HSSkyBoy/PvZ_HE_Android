@tool
extends AdobeAnimateSpriteBase

var timer: float = 0.0

func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    if !canRun:
        return
    timer += delta * timeScale
    offset.y = -20 + sin(timer * 3.0) * 3.0
