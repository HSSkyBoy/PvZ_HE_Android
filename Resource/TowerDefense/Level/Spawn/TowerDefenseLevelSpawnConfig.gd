class_name TowerDefenseLevelSpawnConfig extends Resource

@export var zombie: String = ""
@export var line: int = -1
@export var num: int = 1
@export var override: TowerDefenseCharacterOverride
@export var spawnEvent: Array[TowerDefenseCharacterEventBase] = []
@export var dieEvent: Array[TowerDefenseCharacterEventBase] = []

func Init(spawnDictionary: Dictionary):
    zombie = spawnDictionary.get("Zombie", "")
    line = spawnDictionary.get("Line", -1)
    num = spawnDictionary.get("Num", 1)
    var spawnEventList: Array = spawnDictionary.get("SpawnEvent", []) as Array
    for eventDictionary: Dictionary in spawnEventList:
        var eventName: String = eventDictionary.get("EventName", "")
        if eventName:
            var eventGet = TowerDefenseCharacterEventMathine.EventGet(eventName)
            var eventValue: Dictionary = eventDictionary.get("Value", {})
            eventGet.Init(eventValue)
            spawnEvent.append(eventGet)

    var dieEventList: Array = spawnDictionary.get("DieEvent", []) as Array
    for eventDictionary: Dictionary in dieEventList:
        var eventName: String = eventDictionary.get("EventName", "")
        if eventName:
            var eventGet = TowerDefenseCharacterEventMathine.EventGet(eventName)
            var eventValue: Dictionary = eventDictionary.get("Value", {})
            eventGet.Init(eventValue)
            dieEvent.append(eventGet)

    var overrideData = spawnDictionary.get("Override", {}) as Dictionary
    if !overrideData.is_empty():
        override = TowerDefenseCharacterOverride.new()
        override.Init(overrideData)

func Export() -> Dictionary:
    var data: Dictionary = {
        "Zombie": zombie, 
        "Line": line, 
        "Num": num, 
        "SpawnEvent": [], 
        "DieEvent": [], 
    }
    if is_instance_valid(override):
        data["Override"] = override.Export()
    for event: TowerDefenseCharacterEventBase in spawnEvent:
        data["SpawnEvent"].append(event.Export())
    for event: TowerDefenseCharacterEventBase in dieEvent:
        data["DieEvent"].append(event.Export())
    return data
