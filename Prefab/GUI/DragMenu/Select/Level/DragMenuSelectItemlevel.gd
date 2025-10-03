@tool
extends DragMenuSelectItem

const SILVER_TROPHY = preload("uid://wrip0sbul8kd")
const GOLD_TROPHY = preload("uid://bilmjv3kylwye")
const DIAMOND_TROPHY = preload("uid://bg1gnn1guh1sl")

@onready var cupSprite: Sprite2D = %CupSprite

func Init(levelKey: String) -> void :
    var levelData: Dictionary = GameSaveManager.GetLevelValue(levelKey)
    var difficult: bool = levelData.get_or_add("Difficult", false) || levelData.get_or_add("Ultimate", false)
    if difficult:
        cupSprite.texture = DIAMOND_TROPHY
        return

    var mower: bool = levelData.get_or_add("Mower", false)

    if mower:
        cupSprite.texture = GOLD_TROPHY
        return

    var finish: bool = levelData.get_or_add("Key", {}).get_or_add("Finish", 0) > 0

    if finish:
        cupSprite.texture = SILVER_TROPHY
        return
