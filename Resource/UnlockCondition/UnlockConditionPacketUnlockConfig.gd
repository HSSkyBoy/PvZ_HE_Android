class_name UnlockConditionPacketUnlockConfig extends UnlockConditionBaseConfig

@export var packetName: String = ""

func Check() -> bool:
    var packetData: Dictionary = GameSaveManager.GetTowerDefensePacketValue(packetName)
    return packetData.get("Unlock", {})
