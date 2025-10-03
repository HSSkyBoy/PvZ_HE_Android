class_name TowerDefenseLevelEventConditionNpcTalkFinish extends TowerDefenseLevelEventBase

@export var npcTalkKey: String
@export var finishEventList: Array[TowerDefenseLevelEventBase]
@export var unfinishEventList: Array[TowerDefenseLevelEventBase]

func Execute() -> void :
    if !GameSaveManager.GetTutorialValue(npcTalkKey):
        TowerDefenseManager.ExecuteLevelEvent(unfinishEventList)
    else:
        TowerDefenseManager.ExecuteLevelEvent(finishEventList)

func Init(valueDictionary: Dictionary) -> void :
    npcTalkKey = valueDictionary.get("NpcTalkKey", "")

    var eventFinishList: Array = valueDictionary.get("FinishEvent", []) as Array
    for eventFinishDictionary: Dictionary in eventFinishList:
        var eventName: String = eventFinishDictionary.get("EventName", "")
        if eventName:
            var event = TowerDefenseLevelEventMathine.EventGet(eventName)
            var eventValue: Dictionary = eventFinishDictionary.get("Value", {})
            event.Init(eventValue)
            finishEventList.append(event)

    var eventUnfinishList: Array = valueDictionary.get("UnfinishEvent", []) as Array
    for eventUnfinishDictionary: Dictionary in eventUnfinishList:
        var eventName: String = eventUnfinishDictionary.get("EventName", "")
        if eventName:
            var event = TowerDefenseLevelEventMathine.EventGet(eventName)
            var eventValue: Dictionary = eventUnfinishDictionary.get("Value", {})
            event.Init(eventValue)
            unfinishEventList.append(event)

func GetProperty() -> Dictionary:
    var data = super.GetProperty()
    return data
