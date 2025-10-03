class_name MowerConfig extends Resource

@export var texture: Texture2D
@export var sprite: PackedScene
@export var saveKey: String
@export var unlockCheckList: Array[UnlockConditionBaseConfig]
@export var name: String
@export var describe: String
@export var handbookDescribe: String
@export var handbookStory: String

@export var eventList: Array[MowerEventConfig]

func Execute(character: TowerDefenseCharacter):
    for event in eventList:
        event.Execute(character)

func Unlock() -> bool:
    if Global.debugPacketOpenAll:
        return true
    var mowerOpen = GameSaveManager.GetFeatureValue(saveKey)
    if !mowerOpen:
        if unlockCheckList.size() <= 0:
            return false
        else:
            for unlockCheck: UnlockConditionBaseConfig in unlockCheckList:
                if !unlockCheck.Check():
                    return false
            GameSaveManager.SetFeatureValue(saveKey, true)
            GameSaveManager.Save()
    return true
