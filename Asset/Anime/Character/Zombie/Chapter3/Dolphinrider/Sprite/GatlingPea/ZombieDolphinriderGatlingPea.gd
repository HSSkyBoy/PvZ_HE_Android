@tool
extends AdobeAnimateSpriteBase

@onready var head: AdobeAnimateSpriteBase = %Head

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    if head.is_node_ready():
        head.pause = pause
        head.light_mask = light_mask

func ResetAnimation() -> void :
    super .ResetAnimation()
    head.ResetAnimation()
