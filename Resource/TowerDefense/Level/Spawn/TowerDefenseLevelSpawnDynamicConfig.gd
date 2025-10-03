class_name TowerDefenseLevelSpawnDynamicConfig extends Resource

@export var points: int = 0
@export var zombiePool: Array[String]

func Init(dynamicDictionary: Dictionary) -> void :
    points = dynamicDictionary.get("Point", 0)
    var zombiePoolGet: Array = dynamicDictionary.get("ZombiePool", [])
    zombiePool = Array(zombiePoolGet, TYPE_STRING, "", null)

func Export() -> Dictionary:
    return {
        "Point": points, 
        "ZombiePool": zombiePool
    }
