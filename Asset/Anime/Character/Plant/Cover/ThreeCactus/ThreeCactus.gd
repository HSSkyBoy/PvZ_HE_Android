@tool
extends AdobeAnimateSpriteBase

@onready var head: AdobeAnimateSpriteBase = %Head

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    if Engine.is_editor_hint():
        return
    if head.is_node_ready():
        head.pause = pause
        head.light_mask = light_mask

    if head.clip == "HeadIdle":
        var ToIndex: int = head.clipRange.x + (frameIndex - clipRange.x)
        if head.frameIndex < ToIndex:
            head.timeScale = 2.0
        elif head.frameIndex > ToIndex:
            head.timeScale = 0.5
        else:
            head.timeScale = 1.0
