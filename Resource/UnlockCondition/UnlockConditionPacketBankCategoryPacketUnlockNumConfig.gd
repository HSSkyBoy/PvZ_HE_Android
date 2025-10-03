class_name UnlockConditionPacketBankCategoryPacketUnlockNumConfig extends UnlockConditionBaseConfig

@export var packetBankName: String = ""
@export var category: String = ""
@export var num: int = 1

func Check() -> bool:
    var packetBankData: TowerDefensePacketBankData = TowerDefenseManager.GetPacketBankData(packetBankName)
    var _num: int = 0
    if is_instance_valid(packetBankData):
        var packetList: Array = packetBankData.GetCategory(category)
        for packetName: String in packetList:
            var packetValue: Dictionary = GameSaveManager.GetTowerDefensePacketValue(packetName)
            if packetValue.get_or_add("Unlock", false):
                _num += 1

    return _num >= num
