class_name TowerDefenseLevelEventChangeProtalPos extends TowerDefenseLevelEventBase

func GetName() -> String:
    return "LEVLE_EVENT_CHAGE_PROTAL_POS"

func Execute() -> void :
    TowerDefenseManager.ProtalChangePos()

func Export() -> Dictionary:
    return {
        "EventName": "ChangeProtalPos", 
        "Value": {}
    }
