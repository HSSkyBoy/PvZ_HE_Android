class_name GroundMoveComponent extends ComponentBase

@export var groundNode: Node2D
var groundPosInit: bool = false
var groundPosSave: Vector2 = Vector2.ZERO

var delay: float = 0.2
var parent: TowerDefenseCharacter

func _ready():
    alive = false
    parent = get_parent()
    if groundNode:
        if groundNode is AdobeAnimateSlot:
            var sprite = groundNode.get_parent() as AdobeAnimateSprite
            sprite.animeCompleted.connect(GroundNodeAnimationCompleted)
            sprite.animeBlendCompleted.connect(GroundNodeAnimationCompleted)


@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void :
    if !groundNode:
        return
    if alive && !parent.sprite.pause && !parent.sprite.blend:
        if delay <= 0:
            if !groundPosInit:
                groundPosSave = groundNode.position
                groundPosInit = true
            else:
                parent.global_position.x += GetMoveLength().x
                groundPosSave = groundNode.position
        else:
            delay -= delta
            groundPosSave = Vector2.ZERO
            groundPosInit = false
    else:
        groundPosSave = Vector2.ZERO
        groundPosInit = false

func GetMoveLength() -> Vector2:
    return (groundPosSave - groundNode.position) * parent.spriteGroup.scale.x * parent.scale.x * parent.sprite.scale

@warning_ignore("unused_parameter")
func GroundNodeAnimationCompleted(clip: String) -> void :
    set_deferred("groundPosSave", Vector2.ZERO)
    set_deferred("groundPosInit", false)
