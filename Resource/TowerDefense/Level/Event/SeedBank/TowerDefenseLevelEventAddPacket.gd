class_name TowerDefenseLevelEventAddPacket extends TowerDefenseLevelEventBase

@export var packetName: String
@export var value: Array

func Execute() -> void :
    TowerDefenseManager.AddPacket(packetName)

func Init(valueDictionary: Dictionary) -> void :
    packetName = valueDictionary.get("PacketName", "")
    value = valueDictionary.get("PacketValue", [])
