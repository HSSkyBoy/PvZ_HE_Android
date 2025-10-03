@tool
class_name ShopPageConfig extends Resource

@export var itemList: Array[ShopItemConfig]

func Init(data: Dictionary) -> void :
    var _itemList = data["Item"]
    for itemData: Dictionary in _itemList:
        var itemConfig: ShopItemConfig = ShopItemConfig.new()
        itemConfig.Init(itemData)
        itemList.append(itemConfig)
