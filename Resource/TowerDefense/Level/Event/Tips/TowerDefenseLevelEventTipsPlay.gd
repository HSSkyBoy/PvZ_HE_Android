class_name TowerDefenseLevelEventTipsPlay extends TowerDefenseLevelEventBase

@export var text: String
@export var duration: float = 2.0

func GetName() -> String:
    return "LEVLE_EVENT_TIPS_PLAY"

func Execute() -> void :
    TowerDefenseManager.TipsPlay(text, duration)

func Init(valueDictionary: Dictionary) -> void :
    text = valueDictionary.get("Text", "")
    duration = valueDictionary.get("Duration", 0.0)

func Export() -> Dictionary:
    return {
        "EventName": "TipsPlay", 
        "Value": {
            "Text": text, 
            "Duration": duration
        }
    }

func GetProperty() -> Dictionary:
    var data = super.GetProperty()
    data["播放警告"] = {
        "文本": {
            "Object": self, 
            "Type": "MultilineString", 
            "Property": "text", 
            "Rest": ""
        }, 
        "播放时间": {
            "Object": self, 
            "Type": "Float", 
            "Property": "duration", 
            "Rest": 2.0
        }
    }
    return data
