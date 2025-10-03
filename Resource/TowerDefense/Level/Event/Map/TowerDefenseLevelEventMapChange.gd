class_name TowerDefenseLevelEventMapChange extends TowerDefenseLevelEventBase

@export var mapName: String = "Frontlawn"
@export var duration: float = 0.0
@export var delay: float = 0.0

func GetName() -> String:
    return "LEVLE_EVENT_MAP_CHANGE"

func Execute() -> void :
    TowerDefenseManager.MapChange(mapName, duration, delay)

func Init(valueDictionary: Dictionary) -> void :
    mapName = valueDictionary.get("MapName", "")
    duration = valueDictionary.get("Duration", 0.0)
    delay = valueDictionary.get("Delay", 0.0)

func Export() -> Dictionary:
    return {
        "EventName": "MapChange", 
        "Value": {
            "MapName": mapName, 
            "Duration": duration, 
            "Delay": delay
        }
    }

func GetProperty() -> Dictionary:
    var data = super.GetProperty()
    data["改变地图"] = {
        "地图": {
            "Object": self, 
            "Type": "Enum", 
            "Property": "mapName", 
            "Hint": LevelEditorInformationEditor.instance.mapDictionary, 
            "Rest": "Frontlawn"
        }, 
        "改变时间": {
            "Object": self, 
            "Type": "Float", 
            "Property": "duration", 
            "Rest": 0.0
        }, 
        "延迟时间": {
            "Object": self, 
            "Type": "Float", 
            "Property": "delay", 
            "Rest": 0.0
        }
    }
    return data
