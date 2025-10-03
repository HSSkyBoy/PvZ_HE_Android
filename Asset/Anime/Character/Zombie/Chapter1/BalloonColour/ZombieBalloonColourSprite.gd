@tool
extends AdobeAnimateSpriteBase
@onready var propeller: AdobeAnimateSpriteBase = %Propeller
var head: bool = true

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    if !head:
        return
    if propeller.is_node_ready():
        propeller.pause = pause
        propeller.light_mask = light_mask

func ResetAnimation() -> void :
    super .ResetAnimation()
    if !head:
        return
    propeller.ResetAnimation()
