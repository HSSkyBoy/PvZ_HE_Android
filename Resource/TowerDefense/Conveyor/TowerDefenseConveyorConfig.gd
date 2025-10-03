class_name TowerDefenseConveyorConfig extends Resource

@export var interval: float = 3.0
@export var intervalIncreaseEvery: int = 1000000
@export var intervalMagnification: float = 0.5
@export var packetList: Array[TowerDefenseConveyorPacketConfig] = []
@export var waveEvent: Array = [[], [], [], [], [], [], [], [], [], [], []]

func Init(waveData: Dictionary) -> void :
    packetList.clear()
    interval = waveData.get("Interval", 3.0)
    intervalIncreaseEvery = waveData.get("IntervalIncreaseEvery", 2.0)
    intervalMagnification = waveData.get("IntervalMagnification", 0.5)

    var packetListGet: Array = waveData.get("Packet", [])
    for packetData: Dictionary in packetListGet:
        var packet: TowerDefenseConveyorPacketConfig = TowerDefenseConveyorPacketConfig.new()
        packet.Init(packetData)
        packetList.append(packet)

    waveEvent.clear()
    var waveEventGet: Array = waveData.get("WaveEvent", [])
    for eventListData: Array in waveEventGet:
        var eventList: Array[TowerDefenseConveyorEventBase] = []
        for eventData: Dictionary in eventListData:
            var event: TowerDefenseConveyorEventBase = TowerDefenseConveyorEventEnum.EventGet(eventData.get("EventName", ""))
            event.Init(eventData.get("Value", ""))
            eventList.append(event)
        waveEvent.append(eventList)

func Export() -> Dictionary:
    var data: Dictionary = {
        "Interval" = interval, 
        "IntervalIncreaseEvery" = intervalIncreaseEvery, 
        "IntervalMagnification" = intervalMagnification, 
        "Packet" = [], 
        "WaveEvent" = [], 
    }
    for packetConfig: TowerDefenseConveyorPacketConfig in packetList:
        data["Packet"].append(packetConfig.Export())
    for waveEventList: Array in waveEvent:
        var eventList = []
        for event: TowerDefenseConveyorEventBase in waveEventList:
            eventList.append(event.Export())
        data["WaveEvent"].append(eventList)
    return data
