@tool
class_name ShopItemConfig extends Resource

@export var stageList: Array[ShopItemStageConfig]

func Init(data: Dictionary) -> void :
    var _stageList = data["Stage"]
    for itemStageData: Dictionary in _stageList:
        var itemStageConfig: ShopItemStageConfig = ShopItemStageConfig.new()
        itemStageConfig.Init(itemStageData)
        stageList.append(itemStageConfig)
