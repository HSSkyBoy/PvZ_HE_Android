@tool
class_name MowerHit extends TowerDefenseGroundItemBase

@onready var slot: AdobeAnimateSlot = %AdobeAnimateSlot

@onready var mowerHitSprite: AdobeAnimateSprite = $MowerHitSprite

var _isReady: bool = false

var character: TowerDefenseCharacter

func Init(_character: TowerDefenseCharacter) -> void :
    character = _character
    await get_tree().create_timer(0.1, false).timeout
    var saveScale: Vector2 = character.global_scale
    character.reparent(slot)
    character.position = Vector2.ZERO
    character.global_scale = saveScale
    character.rotation = 0
    character.shadowSprite.visible = false
    if character is TowerDefenseGroundItemBase:
        itemLayer = character.itemLayer
    mowerHitSprite.SetAnimation("animation", false)
    mowerHitSprite.pause = false
    _isReady = true

func _ready() -> void :
    mowerHitSprite.frameIndex = 0

@warning_ignore("unused_parameter")
func AnimeComplete(clip: String) -> void :
    if _isReady:
        if is_instance_valid(character):
            character.Hurt(1000000000.0, true, Vector2.ZERO)
        queue_free()
