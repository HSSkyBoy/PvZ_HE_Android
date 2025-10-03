class_name TowerDefenseLevelDynamicConfig extends Resource

@export var pointIncrementPerWave: int = 0
@export var startingPoints: int = 0
@export var startingWave: int = 0
@export var zombiePool: Array[String]

func Init(dynamicDictionary: Dictionary) -> void :
    pointIncrementPerWave = dynamicDictionary.get("PointIncrementPerWave", 0)
    startingPoints = dynamicDictionary.get("StartingPoints", 0)
    startingWave = dynamicDictionary.get("StartingWave", 0)
    var zombiePoolGet: Array = dynamicDictionary.get("ZombiePool", [])
    zombiePool = Array(zombiePoolGet, TYPE_STRING, "", null)

func Export() -> Dictionary:
    return {
        "PointIncrementPerWave": pointIncrementPerWave, 
        "StartingPoints": startingPoints, 
        "StartingWave": startingWave, 
        "ZombiePool": zombiePool, 
    }
