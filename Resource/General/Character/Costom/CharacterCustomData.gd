@tool
class_name CharacterCustomData extends Resource

@export var customList: Array[CharacterCustomConfig]:
    set(_customList):
        customList = _customList
        Init()
        notify_property_list_changed()

@export var customDictionary: Dictionary = {}
@export var fliterOpenAll: Array[String] = []
@export var fliterCloseAll: Array[String] = []

func Init():
    fliterOpenAll.clear()
    fliterCloseAll.clear()
    customDictionary = {}
    for config: CharacterCustomConfig in customList:
        if config:
            var fliterOpenGet: Array[String] = Array(Array(config.animeFliterOpen.split("&", false)), TYPE_STRING, "", null)
            var fliterCloseGet: Array[String] = Array(Array(config.animeFliterClose.split("&", false)), TYPE_STRING, "", null)
            customDictionary[config.customName] = {
                "Config": config, 
                "Open": fliterOpenGet, 
                "Close": fliterCloseGet
            }
            if !fliterOpenGet.is_empty():
                fliterOpenAll.append_array(fliterOpenGet)
            if !fliterCloseGet.is_empty():
                fliterCloseAll.append_array(fliterCloseGet)

func ClearCustomFliters(sprite: AdobeAnimateSprite):
    sprite.SetFliters(fliterOpenAll, false)
    sprite.SetFliters(fliterCloseAll, true)
    for spriteChild in sprite.get_children():
        if spriteChild is AdobeAnimateSprite:
            spriteChild.SetFliters(fliterOpenAll, false)
            spriteChild.SetFliters(fliterCloseAll, true)

func SetCustomFliters(sprite: AdobeAnimateSprite, customName: String):
    var data: Dictionary = customDictionary[customName]
    sprite.SetFliters(data["Open"], true)
    sprite.SetFliters(data["Close"], false)
    for spriteChild in sprite.get_children():
        if spriteChild is AdobeAnimateSprite:
            spriteChild.SetFliters(data["Open"], true)
            spriteChild.SetFliters(data["Close"], false)

func SetDamagePoint(sprite: AdobeAnimateSprite, customName: String, index: int) -> void :
    var data: Dictionary = customDictionary[customName]
    var config: CharacterCustomConfig = data["Config"]
    sprite.SetReplace(config.damagePointChangeMediaName, config.damagePointChangeMediaTexture[index])
