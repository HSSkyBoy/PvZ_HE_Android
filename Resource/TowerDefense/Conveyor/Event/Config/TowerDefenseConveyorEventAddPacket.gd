class_name TowerDefenseConveyorEventAddPacket extends TowerDefenseConveyorEventBase

@export var packet: TowerDefenseConveyorPacketConfig

func Init(data: Dictionary) -> void :
    super.Init(data)
    packet = TowerDefenseConveyorPacketConfig.new()
    packet.Init(data)

func Execute() -> void :
    var seedBank: TowerDefenseInGameSeedBank = TowerDefenseManager.GetSeedBank()
    seedBank.conveyorBelt.packetList.append(packet)

func Export() -> Dictionary:
    return packet.Export()
