class_name AdobeAnimateTrack extends RefCounted

@export var clip: String = ""
@export var delay: float = 0.0
@export var loop: bool = true
@export var blendTime: float = 0.2

func _init(_clip: String, _delay: float, _loop: bool = true, _blendTime: float = 0.2) -> void :
    clip = _clip
    delay = _delay
    loop = _loop
    blendTime = _blendTime
