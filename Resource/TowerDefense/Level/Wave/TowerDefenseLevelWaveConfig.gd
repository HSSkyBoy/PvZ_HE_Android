class_name TowerDefenseLevelWaveConfig extends Resource

@export var dynamicPlantfood: Array[int]
@export var spawn: Array[TowerDefenseLevelSpawnConfig]
@export var dynamic: TowerDefenseLevelSpawnDynamicConfig = TowerDefenseLevelSpawnDynamicConfig.new()
@export var event: Array[TowerDefenseLevelEventBase]

func Init(waveDictionary: Dictionary) -> void :
    var dynamicPlantfoodGet: Array = waveDictionary.get("DynamicPlantfood") as Array
    dynamicPlantfood = Array(dynamicPlantfoodGet, TYPE_INT, "", null)

    var spawnList: Array = waveDictionary.get("Spawn", []) as Array
    for spawnDictionary: Dictionary in spawnList:
        var spawnConfig: TowerDefenseLevelSpawnConfig = TowerDefenseLevelSpawnConfig.new()
        spawnConfig.Init(spawnDictionary)
        spawn.append(spawnConfig)

    var dynamicData: Dictionary = waveDictionary.get("Dynamic", {}) as Dictionary
    dynamic = TowerDefenseLevelSpawnDynamicConfig.new()
    dynamic.Init(dynamicData)

    var eventList: Array = waveDictionary.get("Event", []) as Array
    for eventDictionary: Dictionary in eventList:
        var eventName: String = eventDictionary.get("EventName", "")
        if eventName:
            var eventGet = TowerDefenseLevelEventMathine.EventGet(eventName)
            var eventValue: Dictionary = eventDictionary.get("Value", {})
            eventGet.Init(eventValue)
            event.append(eventGet)

func Export() -> Dictionary:
    var data: Dictionary = {
        "DynamicPlantfood": dynamicPlantfood, 
        "Spawn": [], 
        "Dynamic": dynamic.Export(), 
        "Event": [], 
    }
    for spawnGet: TowerDefenseLevelSpawnConfig in spawn:
        data["Spawn"].append(spawnGet.Export())
    for eventGet: TowerDefenseLevelEventBase in event:
        data["Event"].append(eventGet.Export())
    return data
