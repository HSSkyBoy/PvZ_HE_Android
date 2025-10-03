class_name TowerDefensePacketOverride extends Resource

@export_category("Total")
@export var type: TowerDefenseEnum.PACKET_TYPE = TowerDefenseEnum.PACKET_TYPE.NOONE
@export_category("Total")
@export var costRise: int = -1
@export var cost: int = -1
@export var packetCooldown: float = -1
@export var startingCooldown: float = -1
@export_category("Zombie")
@export var weight: int = -1
@export var wavePointCost: int = -1
@export_category("Event")
@export var eventPress: Array[TowerDefensePacketEventBase]
@export var eventPlant: Array[TowerDefensePacketEventBase]
@export_category("Character")
@export var plantCover: Array[String] = []
@export var characterOverride: TowerDefenseCharacterOverride

@export var islimitGridNum: bool = true
@export var coverCanDirectPlant: bool = false

func Init(data: Dictionary) -> void :
    type = TowerDefenseEnum.PACKET_TYPE.get(str(data.get("Type", "NOONE")).to_upper())
    costRise = data.get("CostRise", -1)
    cost = data.get("Cost", -1)
    packetCooldown = data.get("PacketCooldown", -1)
    startingCooldown = data.get("StartingCooldown", -1)

    weight = data.get("Weight", -1)
    wavePointCost = data.get("WavePointCost", -1)

    plantCover = Array(data.get("PlantCover", []), TYPE_STRING, "", null)

    var eventPressList: Array = data.get("EventPress", []) as Array
    for eventPressDictionary: Dictionary in eventPressList:
        var eventName: String = eventPressDictionary.get("EventName", "")
        if eventName:
            var event = TowerDefensePacketEventMathine.EventGet(eventName)
            var eventValue: Dictionary = eventPressDictionary.get("Value", {})
            event.Init(eventValue)
            eventPress.append(event)

    var eventPlantList: Array = data.get("EventPlant", []) as Array
    for eventPlantDictionary: Dictionary in eventPlantList:
        var eventName: String = eventPlantDictionary.get("EventName", "")
        if eventName:
            var event = TowerDefensePacketEventMathine.EventGet(eventName)
            var eventValue: Dictionary = eventPlantDictionary.get("Value", {})
            event.Init(eventValue)
            eventPlant.append(event)

    characterOverride = TowerDefenseCharacterOverride.new()
    characterOverride.Init(data.get("CharacterOverride", {}))

    islimitGridNum = data.get("IslimitGridNum", true)
    coverCanDirectPlant = data.get("CoverCanDirectPlant", false)

func Export() -> Dictionary:
    var data = {
        "Type" = TowerDefenseEnum.PACKET_TYPE.find_key(type), 
        "CostRise" = costRise, 
        "Cost" = cost, 
        "PacketCooldown" = packetCooldown, 
        "StartingCooldown" = startingCooldown, 
        "Weight" = weight, 
        "WavePointCost" = wavePointCost, 

        "EventPress" = [], 
        "EventPlant" = [], 

        "PlantCover" = plantCover, 
        "CharacterOverride" = characterOverride.Export(), 

        "IslimitGridNum" = islimitGridNum, 
        "CoverCanDirectPlant" = coverCanDirectPlant
    }
    for eventGet: TowerDefensePacketEventBase in eventPress:
        data["EventPress"].append(eventGet.Export())
    for eventGet: TowerDefensePacketEventBase in eventPlant:
        data["EventPlant"].append(eventGet.Export())
    return data
