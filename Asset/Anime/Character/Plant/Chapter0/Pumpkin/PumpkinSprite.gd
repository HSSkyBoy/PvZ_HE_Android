@tool
extends AdobeAnimateSpriteBase

@onready var back: AdobeAnimateSpriteBase = %Back

func _physics_process(delta: float) -> void :
    super ._physics_process(delta)
    back.frameIndex = frameIndex
