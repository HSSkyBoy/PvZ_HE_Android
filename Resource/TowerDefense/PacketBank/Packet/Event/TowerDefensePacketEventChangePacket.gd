class_name TowerDefensePacketEventChangePacket extends TowerDefensePacketEventBase

@export var levelPacketConfig: TowerDefenseLevelPacketConfig

@warning_ignore("unused_parameter")
func Init(data: Dictionary) -> void :
    levelPacketConfig = TowerDefenseLevelPacketConfig.new()
    levelPacketConfig.Init(data)

@warning_ignore("unused_parameter")
func Execute(packet: TowerDefenseInGamePacketShow) -> void :
    var packetConfig: TowerDefensePacketConfig = levelPacketConfig.GetPacket()
    packet.Init(packetConfig)
