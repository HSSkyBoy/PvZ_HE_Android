class_name TutorialStepConfig extends Resource

@export var broadCastUse: bool = false
@export var broadCastConfig: BroadCastConfig
@export var conditionList: Array[TutorialConditionConfig]

func Init(data: Dictionary) -> void :
    broadCastUse = false
    broadCastConfig = null
    conditionList.clear()
    if data.has("BroadCast"):
        broadCastUse = true
        broadCastConfig = BroadCastConfig.new()
        broadCastConfig.broadCastString = data["BroadCast"].get("Text", "")
        broadCastConfig.broadCastTime = data["BroadCast"].get("Time", -1)
    for conditionData: Dictionary in data.get("Condition", []):
        var conditionConfig: TutorialConditionConfig = TutorialEnum.GetCondition(conditionData["Name"])
        conditionConfig.Init(conditionData["Data"])
        conditionList.append(conditionConfig)

func Enter() -> void :
    for condition: TutorialConditionConfig in conditionList:
        condition.Enter()

func Exit() -> void :
    pass

func Step() -> bool:
    for condition: TutorialConditionConfig in conditionList:
        if !condition.Step():
            return false
    return true
