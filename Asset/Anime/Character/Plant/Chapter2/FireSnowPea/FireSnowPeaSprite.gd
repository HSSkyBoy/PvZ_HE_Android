@tool
extends AdobeAnimateSpriteBase

@onready var headRight: AdobeAnimateSpriteBase = %HeadRight
@onready var headLeft: AdobeAnimateSpriteBase = %HeadLeft

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    if Engine.is_editor_hint():
        return
    if headRight.is_node_ready():
        headRight.pause = pause
        headRight.light_mask = light_mask

    if headLeft.is_node_ready():
        headLeft.pause = pause
        headLeft.light_mask = light_mask

    if headRight.clip == "FlameHeadIdle":
        var ToIndex: int = headRight.clipRange.x + (frameIndex - clipRange.x)
        if headRight.frameIndex < ToIndex - 1:
            headLeft.timeScale = 2.0
            headRight.timeScale = 2.0
        elif headRight.frameIndex > ToIndex + 1:
            headLeft.timeScale = 0.5
            headRight.timeScale = 0.5
        else:
            headLeft.timeScale = 1.0
            headRight.timeScale = 1.0
