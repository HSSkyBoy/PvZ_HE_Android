@tool
class_name TowerDefenseEffectSpriteOnce extends TowerDefenseEffectBase

@export var objectId: ObjectManagerConfig.OBJECT = ObjectManagerConfig.OBJECT.NOONE
@export var sprite: AdobeAnimateSprite
@export var clipsList: PackedStringArray
var currentIndex: int = 0

func Refresh() -> void :
    add_to_group("Effect")
    currentIndex = 0
    sprite.frameBlend = 0
    sprite.SetAnimation(clipsList[currentIndex], false, 0.0)

func Recycle() -> void :
    remove_from_group("Effect")

func _ready() -> void :
    if sprite:
        if !sprite.animeCompleted.is_connected(AnimeCompleted):
            sprite.animeCompleted.connect(AnimeCompleted)

func Init(spriteScene: PackedScene, _clip: String = "") -> void :
    sprite = spriteScene.instantiate()
    if _clip != "":
        currentIndex = 0
        clipsList = _clip.split("|", false)
        sprite.SetAnimation(clipsList[currentIndex], false, 0.0)
    add_child(sprite)
    sprite.animeCompleted.connect(AnimeCompleted)

@warning_ignore("unused_parameter")
func AnimeCompleted(clip: String) -> void :
    if clipsList.size() > 0:
        if currentIndex < clipsList.size() - 1:
            currentIndex += 1
            sprite.SetAnimation(clipsList[currentIndex], false, 0.1)
            return

    if objectId == ObjectManagerConfig.OBJECT.NOONE:
        queue_free()
    else:
        ObjectManager.PoolPush(objectId, self)
