@tool
extends DragMenuSelectItem

const SILVER_MEDAL = preload("uid://bch4iu18n3i44")
const GOLD_MEDAL = preload("uid://dqgpqtvy8kej3")
const DIMOND_MEDAL = preload("uid://biqnbmrdvhih7")

@onready var cupSprite: Sprite2D = %CupSprite

func Init(chapter: Dictionary) -> void :
    var diamond: bool = true
    var gold: bool = true
    var silver: bool = true
    var levelList = chapter["Level"]
    if levelList.size() <= 0:
        diamond = false
        gold = false
        silver = false
    for levelListId in range(levelList.size()):
        var level: Dictionary = levelList[levelListId]
        var levelKey: String = level["SaveKey"]
        var levelData: Dictionary = GameSaveManager.GetLevelValue(levelKey)
        var difficult: bool = levelData.get_or_add("Difficult", false) || levelData.get_or_add("Ultimate", false)
        if !difficult:
            diamond = false

        var mower: bool = levelData.get_or_add("Mower", false)

        if !mower:
            gold = false

        var finish: bool = levelData.get_or_add("Key", {}).get_or_add("Finish", 0) > 0

        if !finish:
            silver = false
    if silver:
        cupSprite.texture = SILVER_MEDAL
    if gold:
        cupSprite.texture = GOLD_MEDAL
    if diamond:
        cupSprite.texture = DIMOND_MEDAL
