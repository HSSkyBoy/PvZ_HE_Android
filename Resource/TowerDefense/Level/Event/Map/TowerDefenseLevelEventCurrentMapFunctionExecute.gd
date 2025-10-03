class_name TowerDefenseLevelEventCurrentMapFunctionExecute extends TowerDefenseLevelEventBase

@export var functionName: String
@export var value: Array

func GetName() -> String:
    return "LEVLE_EVENT_CURRENTMAP_FUNCTION_EXECUTE"

func Execute() -> void :
    var currentMap: TowerDefenseMap = TowerDefenseManager.GetCurrentMap()
    if currentMap:
        currentMap.FunctionExecute(functionName, value)

func Init(valueDictionary: Dictionary) -> void :
    functionName = valueDictionary.get("FunctionName", "")
    value = valueDictionary.get("Value", [])

func Export() -> Dictionary:
    return {
        "EventName": "CurrentMapCharacterClear", 
        "Value": {
            "FunctionName": functionName, 
            "Value": value
        }
    }
