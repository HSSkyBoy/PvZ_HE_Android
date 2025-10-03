@tool
class_name ShopConfig extends Resource

@export var data: JSON:
    set(_data):
        data = _data
        Init()
        notify_property_list_changed()
@export var pageList: Array[ShopPageConfig]

func Init() -> void :
    pageList.clear()
    var _pageList = data.data["Page"]
    for pageData in _pageList:
        var pageConfig: ShopPageConfig = ShopPageConfig.new()
        pageConfig.Init(pageData)
        pageList.append(pageConfig)
