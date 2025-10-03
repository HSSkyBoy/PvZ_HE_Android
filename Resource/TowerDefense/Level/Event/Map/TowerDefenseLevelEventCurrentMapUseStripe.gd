class_name TowerDefenseLevelEventCurrentMapUseStripe extends TowerDefenseLevelEventBase

@export var row: int = 3

func GetName() -> String:
    return "LEVLE_EVENT_CURRENTMAP_USE_STRIPE"

func Execute() -> void :
    var currentMap: TowerDefenseMap = TowerDefenseManager.GetCurrentMap()
    if currentMap:
        currentMap.UseStripe(row)

func Init(valueDictionary: Dictionary) -> void :
    row = valueDictionary.get("Row", [])

func Export() -> Dictionary:
    return {
        "EventName": "CurrentMapUseStripe", 
        "Value": {
            "Row": row
        }
    }

func GetProperty() -> Dictionary:
    var data = super.GetProperty()
    data["使用红线"] = {
        "列": {
            "Object": self, 
            "Type": "Int", 
            "Property": "row", 
            "Rest": 3
        }
    }
    return data
