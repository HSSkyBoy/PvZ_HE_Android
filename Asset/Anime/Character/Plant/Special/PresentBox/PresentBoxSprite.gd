@tool
extends AdobeAnimateSpriteBase

func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    if !canRun:
        return
    offset = Vector2(-40, -40) + Vector2(randf_range(-1, 1), randf_range(-1, 1))
