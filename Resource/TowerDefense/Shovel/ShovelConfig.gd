class_name ShovelConfig extends Resource

@export var texture: Texture2D
@export var saveKey: String
@export var unlockCheckList: Array[UnlockConditionBaseConfig]
@export var name: String
@export var describe: String
@export var handbookDescribe: String
@export var handbookStory: String

@export var eventList: Array[ShovelEventConfig]

func Execute(character: TowerDefenseCharacter):
    for event in eventList:
        event.Execute(character)

func Unlock() -> bool:
    if Global.debugPacketOpenAll:
        return true
    var shovelOpen = GameSaveManager.GetFeatureValue(saveKey)
    if !shovelOpen:
        if unlockCheckList.size() <= 0:
            return false
        else:
            for unlockCheck: UnlockConditionBaseConfig in unlockCheckList:
                if !unlockCheck.Check():
                    return false
            GameSaveManager.SetFeatureValue(saveKey, true)
            GameSaveManager.Save()
    return true
