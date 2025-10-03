class_name TowerDefenseLevelVaseFillConfig extends Resource

@export var packetName: String = ""
@export var override: TowerDefensePacketOverride

func Init(data: Dictionary) -> void :
    packetName = data.get("PacketName", "")
    if data.has("Override"):
        override = TowerDefensePacketOverride.new()
        override.Init(data.get("Override", {}))

func Export() -> Dictionary:
    var data: Dictionary = {
        "PacketName": packetName, 
    }
    if is_instance_valid(override):
        data["Override"] = override.Export()
    return data

func GetPacket() -> TowerDefensePacketConfig:
    var packet: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(packetName).duplicate(true)
    if is_instance_valid(override):
        packet.override = override
    return packet
