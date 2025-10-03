class_name TowerDefenseLevelEventSetGameMode extends TowerDefenseLevelEventBase

@export var gameMode: TowerDefenseEnum.GAMEMODE = TowerDefenseEnum.GAMEMODE.TOWERDEFENSE

func GetName() -> String:
    return "LEVLE_EVENT_SET_GAME_MODE"

func Execute() -> void :
    TowerDefenseManager.currentControl.gameMode = gameMode

func Init(valueDictionary: Dictionary) -> void :
    gameMode = TowerDefenseEnum.GAMEMODE.get(valueDictionary.get("GameMode", "TOWERDEFENSE").to_upper())

func Export() -> Dictionary:
    return {
        "EventName": "SetGameMode", 
        "Value": {
            "GameMode": TowerDefenseEnum.GAMEMODE.find_key(gameMode)
        }
    }

func GetProperty() -> Dictionary:
    var data = super .GetProperty()
    data["游戏模式"] = {
        "模式": {
            "Object": self, 
            "Type": "Enum", 
            "Property": "gameMode", 
            "Hint": TowerDefenseEnum.GAMEMODE, 
            "Rest": TowerDefenseEnum.GAMEMODE.TOWERDEFENSE
        }
    }
    return data
