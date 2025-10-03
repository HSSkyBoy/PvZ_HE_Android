@tool
class_name CharacterArmorData extends Resource

@export var armorList: Array[CharacterArmorConfig]:
    set(_armorList):
        armorList = _armorList
        Init()

@export var armorDictionary: Dictionary = {}
@export var fliterAllDictionary: Dictionary = {}
@export var fliterOpenDictionary: Dictionary = {}
@export var fliterCloseDictionary: Dictionary = {}
func Init() -> void :
    fliterAllDictionary = {}
    armorDictionary = {}
    fliterOpenDictionary = {}
    fliterCloseDictionary = {}
    for config: CharacterArmorConfig in armorList:
        if config:
            armorDictionary[config.armorName] = config
            var emptyFliter: Array[String] = []
            fliterAllDictionary[config.armorName] = emptyFliter.duplicate()
            var fliterGet: Array[String] = Array(Array(config.destroyFliter.split("&", false)), TYPE_STRING, "", null)
            if !fliterGet.is_empty():
                fliterAllDictionary[config.armorName].append_array(fliterGet)

            fliterOpenDictionary[config.armorName] = emptyFliter.duplicate()
            var fliterOpenGet: Array[String] = Array(Array(config.openFliter.split("&", false)), TYPE_STRING, "", null)
            if !fliterOpenGet.is_empty():
                fliterOpenDictionary[config.armorName].append_array(fliterOpenGet)

            fliterCloseDictionary[config.armorName] = emptyFliter.duplicate()
            var fliterCloseGet: Array[String] = Array(Array(config.closeFliter.split("&", false)), TYPE_STRING, "", null)
            if !fliterCloseGet.is_empty():
                fliterCloseDictionary[config.armorName].append_array(fliterCloseGet)


func ClearArmorFlitersAll(sprite: AdobeAnimateSprite) -> void :
    for armorName: String in fliterAllDictionary.keys():
        ClearArmorFliters(sprite, armorName)

func ClearArmorFliters(sprite: AdobeAnimateSprite, armorName: String) -> void :
    sprite.SetFliters(fliterAllDictionary[armorName], false)
    sprite.SetFliters(fliterCloseDictionary[armorName], true)
    sprite.SetFliters(fliterOpenDictionary[armorName], false)

func OpenArmorFlitersAll(sprite: AdobeAnimateSprite) -> void :
    for armorName: String in fliterAllDictionary.keys():
        OpenArmorFliters(sprite, armorName)

func OpenArmorFliters(sprite: AdobeAnimateSprite, armorName: String) -> void :
    sprite.SetFliters(fliterAllDictionary[armorName], true)
    sprite.SetFliters(fliterCloseDictionary[armorName], false)
    sprite.SetFliters(fliterOpenDictionary[armorName], true)

func SetArmorReplace(sprite: AdobeAnimateSprite, armorName: String, stage: int) -> void :
    var stageTexture = armorDictionary[armorName].stageAnimeTexture
    if stageTexture.size() > 0:
        var replaceTexture: Texture2D = stageTexture[stage]
        sprite.SetReplace(armorDictionary[armorName].replaceMediaName, replaceTexture)
