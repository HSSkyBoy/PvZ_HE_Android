class_name TowerDefenseLevelVaseConfig extends Resource

@export var packetName: String = ""
@export var override: TowerDefensePacketOverride
@export var gridPos: Vector2i
@export var type: String

func Init(data: Dictionary) -> void :
    packetName = data.get("PacketName", "")
    if data.has("Override"):
        override = TowerDefensePacketOverride.new()
        override.Init(data.get("Override", {}))
    type = data.get("Type", "Normal")
    var gridPosGet = data.get_or_add("GridPos", Vector2i.ZERO)
    gridPos = Vector2i(gridPosGet[0], gridPosGet[1])

func Export() -> Dictionary:
    var data: Dictionary = {
        "PacketName": packetName, 
        "Type": type, 
        "GridPos": [gridPos.x, gridPos.y]
    }
    if is_instance_valid(override):
        data["Override"] = override.Export()
    return data

func GetPacket() -> TowerDefensePacketConfig:
    if packetName == "":
        return null
    var packet: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(packetName).duplicate(true)
    if is_instance_valid(override):
        packet.override = override
    return packet
