class_name TowerDefenseRainModeConfig extends Resource

@export var aliveTime: float = 30.0
@export var interval: float = 3.0
@export var packetList: Array = []

func Init(waveData: Dictionary) -> void :
    packetList.clear()
    aliveTime = waveData.get("AliveTime", 15.0)
    interval = waveData.get("Interval", 3.0)

    var packetListGet: Array = waveData.get("Packet", [])
    for packetData: Dictionary in packetListGet:
        var packet: TowerDefenseRainModePacketConfig = TowerDefenseRainModePacketConfig.new()
        packet.Init(packetData)
        packetList.append(packet)

func Export() -> Dictionary:
    var data: Dictionary = {
        "AliveTime" = aliveTime, 
        "Interval" = interval, 
        "Packet" = [], 
    }
    for packetConfig: TowerDefenseRainModePacketConfig in packetList:
        data["Packet"].append(packetConfig.Export())
    return data
