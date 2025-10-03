class_name TowerDefenseRainModePacketConfig extends Resource

@export var name: String = ""
@export var weight: int = 10
@export var maxNum: int = -1
@export var maxMagnification: float = 0.1
@export var minNum: int = -1
@export var minMagnification: float = 2
@export var override: TowerDefensePacketOverride

func Init(data: Dictionary) -> void :
    name = data.get("Name", "")
    weight = data.get("Weight", 0)
    maxNum = data.get("MaxNum", -1)
    maxMagnification = data.get("MaxMagnification", 0)
    minNum = data.get("MinNum", -1)
    minMagnification = data.get("MinMagnification", 0)
    if data.has("Override"):
        override = TowerDefensePacketOverride.new()
        override.Init(data.get("Override", {}))

func Export() -> Dictionary:
    var data = {
        "Name" = name, 
        "Weight" = weight, 
        "MaxNum" = maxNum, 
        "MaxMagnification" = maxMagnification, 
        "MinNum" = minNum, 
        "MinMagnification" = minMagnification, 
    }
    if is_instance_valid(override):
        data["Override"] = override.Export()
    return data

func GetPacket() -> TowerDefensePacketConfig:
    var packet: TowerDefensePacketConfig = TowerDefenseManager.GetPacketConfig(name).duplicate(true)
    if is_instance_valid(override):
        packet.override = override
    return packet
