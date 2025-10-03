@tool
extends AdobeAnimateSpriteBase

@onready var flag: AdobeAnimateSpriteBase = %ZombieFlagpole

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    super._physics_process(delta)
    if flag.is_node_ready():
        flag.pause = pause
        flag.light_mask = light_mask
