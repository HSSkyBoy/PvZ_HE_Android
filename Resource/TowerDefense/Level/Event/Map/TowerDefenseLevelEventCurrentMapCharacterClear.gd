class_name TowerDefenseLevelEventCurrentMapCharacterClear extends TowerDefenseLevelEventBase

func GetName() -> String:
    return "LEVLE_EVENT_CURRENTMAP_CHARACTER_CLEAR"

func Execute() -> void :
    var currentMap: TowerDefenseMap = TowerDefenseManager.GetCurrentMap()
    if currentMap:
        currentMap.CharacterClear()

func Export() -> Dictionary:
    return {
        "EventName": "CurrentMapCharacterClear", 
        "Value": {}
    }
