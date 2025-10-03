@tool
class_name TowerDefenseIceCap extends TowerDefenseGroundItemBase

@onready var iceSprite = %IceSprite
@onready var iceCapSprite = %IceCapSprite

@export var length: float = 0:
    set(_length):
        length = _length
        clearTimer = clearTime
@export var clearTime: float = 90.0

var clearTimer: float = 0.0

func _ready() -> void :
    if Engine.is_editor_hint():
        return
    iceSprite.material = iceSprite.material.duplicate()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if Engine.is_editor_hint():
        return
    iceSprite.scale.x = 1 + length / 150.0
    iceCapSprite.position.x = - length
    var iceMaterial = iceSprite.material as ShaderMaterial
    iceMaterial.set_shader_parameter("iceLength", 150 + length)
    if clearTime > 0:
        clearTime -= delta
    else:
        queue_free()
